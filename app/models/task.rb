class Task < ActiveRecord::Base
  belongs_to :plant

  PHAENOLOG_SEASONS = [ :vorfrühling, :erstfrühling, :vollfrühling,
                        :frühsommer, :hochsommer, :spätsommer,
                        :frühherbst, :vollherbst, :spätherbst,
                        :winter ]
  enum start: PHAENOLOG_SEASONS
  enum stop:  PHAENOLOG_SEASONS.map{ |s| ("ende_" + s.to_s).to_sym }
  enum repeat: [:einmalig, :jährlich]

  def self.all_for_user(user)
    # TODO: should be cached; does not work
    @all_for_user ||= self.where(hide: false).where('plant_id IN (?)', user.plants.select(:id))
  end

  def self.current_tasks_for_user(user)
    repeating_task_ids = self.all_for_user(user)
                        .where('start <= ? AND stop >= ?', current_season, current_season)
                        .where(repeat: self.repeats[:jährlich])
                        .pluck(:id)

    # TODO: year is not correct since it could be
    # a task that should be made in winter sometime but has already been done last year (in winter)
    task_ids = repeating_task_ids - user.done_tasks.where(year: Date.today.year).pluck(:id)

    single_task_ids = self.all_for_user(user)
                        .where('start <= ? AND stop >= ?', current_season, current_season)
                        .where(repeat: self.repeats[:einmalig])
                        .pluck(:id)

    task_ids += single_task_ids - user.done_tasks.pluck(:id)
    self.where('id in (?)', task_ids).includes(:plant)
  end

  def done?
    ( repeat == :einmalig && DoneTask.where(task_id: :id).exists? ) ||
    ( repeat == :jährlich && DoneTask.where(task_id: :id, year: Date.today.year).exists?)
  end

private

  def self.current_season
    2
  end
end
