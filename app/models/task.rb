class Task < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :plant
  has_many :done_tasks
  has_many :skipped_tasks, -> {where(skipped: true)}, class_name: "DoneTask"

  enum start: Season::PHAENOLOG_SEASONS
  enum stop:  Season::PHAENOLOG_SEASONS.map{ |s| ("ende_" + s.to_s).to_sym }
  enum repeat: [:einmalig, :täglich, :wöchentlich, :monatlich, :halbjährlich, :jährlich]

  def self.all_for_user(user, hide=false)
    self.where(hide: hide).where('plant_id IN (?)', user.plants.where(active: true).select(:id))
  end

  def self.upcoming_tasks_for_user(user)
    season = Season::current.season_index

    current_tasks = self.all_for_user(user)
                    .where('start <= ? AND stop >= ?', season, season)
                    .includes(:done_tasks, :plant)
                    .references(:done_tasks)
    upcoming_tasks = []
    current_tasks.each do |task|
      upcoming_tasks.push(task) unless (task.done? || task.skipped?)
    end
    upcoming_tasks
  end

  def current_done_task
    current_done_task = case repeat
      when "einmalig"     then single_done_task
      when "jährlich"     then yearly_done_task
      when "täglich"      then daily_done_task
      when "wöchentlich"  then weekly_done_task
      when "monatlich"    then monthly_done_task
      when "halbjährlich" then half_yearly_done_task
    end
    current_done_task
  end

  def single_done_task
    if done_tasks.empty?
      nil
    else
      done_tasks.first
    end
  end

  def yearly_done_task
    done_tasks.each do |done_task|
      return done_task if done_task.date.year == Date.today.year
      # TODO: not correct in winter!!
    end
    nil
  end

  def daily_done_task
    done_tasks.each do |done_task|
      return done_task if done_task.date.to_date == Date.today
    end
    nil
  end

  def weekly_done_task
    done_tasks.each do |done_task|
      return done_task if done_task.date + 7.days >= Date.today
    end
    nil
  end

  def monthly_done_task
    done_tasks.each do |done_task|
      return done_task if done_task.date + 1.month >= Date.today
    end
    nil
  end

  def half_yearly_done_task
    done_tasks.each do |done_task|
      return done_task if done_task.date + 6.months >= Date.today
    end
    nil
  end

  def done?
    !current_done_task.nil? && !current_done_task.skipped
  end

  def skipped?
    !current_done_task.nil? && current_done_task.skipped
  end

  def upcoming?
    p Season::current.season_index
    current_done_task.nil? && Task.starts[start] <= Season::current.season_index && Task.stops[stop] >= Season::current.season_index
  end
end
