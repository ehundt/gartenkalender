class Task < ActiveRecord::Base
  belongs_to :plant
  has_many :done_task

  enum start: Season::PHAENOLOG_SEASONS
  enum stop:  Season::PHAENOLOG_SEASONS.map{ |s| ("ende_" + s.to_s).to_sym }
  enum repeat: [:einmalig, :jährlich]

  def self.all_for_user(user, hide=false)
    # TODO: should be cached; does not work
    @all_for_user ||= self.where(hide: hide).where('plant_id IN (?)', user.plants.where(active: true).select(:id))
  end

  def self.upcoming_tasks_for_user(user)
    repeating_task_ids = self.all_for_user(user)
                        .where('start <= ? AND stop >= ?', current_season, current_season)
                        .where(repeat: self.repeats[:jährlich])
                        .pluck(:id)

    # TODO: year is not correct since it could be
    # a task that should be made in winter sometime but has already been done last year (in winter)
    done_repeating_tasks = DoneTask.where('task_id in (?)', repeating_task_ids).where(year: Date.today.year).pluck(:task_id)
    task_ids = repeating_task_ids - done_repeating_tasks

    single_task_ids = self.all_for_user(user)
                        .where('start <= ? AND stop >= ?', current_season, current_season)
                        .where(repeat: self.repeats[:einmalig])
                        .pluck(:id)

    task_ids += single_task_ids - DoneTask.where('task_id in (?)', single_task_ids).pluck(:task_id)
    self.where('id in (?)', task_ids).includes(:plant)
  end

  def done?
    ( repeat == :einmalig && DoneTask.where(task_id: :id).exists? ) ||
    ( repeat == :jährlich && DoneTask.where(task_id: :id, year: Date.today.year).exists?)
  end

  def upcoming?
    Task.starts[start] <= Task.current_season #&& stop >= Task.current_season && !done?
  end

private

  def self.current_season
    2
  end
end
