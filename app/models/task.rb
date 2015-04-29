class Task < ActiveRecord::Base
  belongs_to :plant
  has_many :done_tasks
  has_many :skipped_tasks, -> {where(skipped: true)}, class_name: "DoneTask"

  enum start: Season::PHAENOLOG_SEASONS
  enum stop:  Season::PHAENOLOG_SEASONS.map{ |s| ("ende_" + s.to_s).to_sym }
  enum repeat: [:einmalig, :täglich, :wöchentlich, :monatlich, :halbjährlich, :jährlich]

  def self.all_for_user(user, hide=false)
    # TODO: should be cached?
    self.where(hide: hide).where('plant_id IN (?)', user.plants.where(active: true).select(:id))
  end

  def self.upcoming_tasks_for_user(user)
    current_tasks = self.all_for_user(user)
                    .where('start <= ? AND stop >= ?', Season::current, Season::current)
                    .includes(:done_tasks, :plant)
                    .where("done_tasks.year = ?", Date.today.year) # TODO
                    .references(:done_tasks)
    upcoming_tasks = []
    current_tasks.each do |task|
      upcoming_tasks.push(task) unless (task.done? || task.skipped?)
    end
    upcoming_tasks
  end
  # def self.upcoming_tasks_for_user(user)
  #   repeating_task_ids = self.all_for_user(user)
  #                       .where('start <= ? AND stop >= ?', Season::current, Season::current)
  #                       .where(repeat: self.repeats[:jährlich])
  #                       .pluck(:id)

  #   # TODO: year is not correct since it could be
  #   # a task that should be made in winter sometime but has already been done last year (in winter)
  #   done_repeating_tasks = DoneTask.where('task_id in (?)', repeating_task_ids).where(year: Date.today.year).pluck(:task_id)
  #   task_ids = repeating_task_ids - done_repeating_tasks

  #   single_task_ids = self.all_for_user(user)
  #                       .where('start <= ? AND stop >= ?', Season::current, Season::current)
  #                       .where(repeat: self.repeats[:einmalig])
  #                       .pluck(:id)

  #   task_ids += single_task_ids - DoneTask.where('task_id in (?)', single_task_ids).pluck(:task_id)
  #   self.where('id in (?)', task_ids).includes(:plant)
  # end

  # TODO: rename done_task to sth. else
  def current_done_task
    current_done_task = case repeat
      when :einmalig     then single_done_task
      when :jährlich     then yearly_done_task
      when :täglich      then daily_done_task
      when :wöchentlich  then weekly_done_task
      when :monatlich    then monthly_done_task
      when :halbjährlich then half_yearly_done_task
    end
  end

  def single_done_task
    if task.done_tasks.empty?
      nil
    else
      task.done_tasks.first
    end
  end

  def yearly_done_task
    task.done_tasks.each do |done_task|
      return done_task if done_task.year == Date.today.year
      # TODO: not correct in winter!!
    end
  end

  def daily_done_task
    task.done_tasks.each do |done_task|
      return done_task if done_task.date == Date.today
    end
  end

  def weekly_done_task
    task.done_tasks.each do |done_task|
      return done_task if done_task.date + 7.days >= Date.today
    end
  end

  def monthly_done_task
    task.done_tasks.each do |done_task|
      return done_task if done_task.date + 1.month >= Date.today
    end
  end

  def half_yearly_done_task
    task.done_tasks.each do |done_task|
      return done_task if done_task.date + 6.months >= Date.today
    end
  end

  def done?
    !current_done_task.nil? && !current_done_task.skipped
  end

  def skipped?
    !current_done_task.nil? && current_done_task.skipped
  end

  def upcoming?
    current_done_task.nil? && Task.starts[start] <= Season::current && Task.stops[stop] >= Season::current
  end
end
