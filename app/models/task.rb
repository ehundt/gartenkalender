class Task < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :plant
  has_many :done_tasks
  has_many :skipped_tasks, -> {where(skipped: true)}, class_name: "DoneTask"

  enum repeat: [:einmalig, :täglich, :wöchentlich, :monatlich, :halbjährlich, :jährlich]

  validates :title, presence: true

  scope :in_time_frame, -> {
    search_for_date = Date.today.change(year: 1)
    search_for_date2 = Date.today.change(year: 2)

    where('(begin_date <= ? AND end_date >= ?) OR (begin_date <= ? AND end_date >= ?)',
          search_for_date, search_for_date, search_for_date2, search_for_date2)
  }

  def self.all_for_user(user, hide=false)
    self.where(hide: hide).where('plant_id IN (?)', user.plants.where(active: true).select(:id))
  end

  def self.upcoming_tasks_for_user(user)
    current_tasks = self.all_for_user(user).in_time_frame
                    .includes(:done_tasks, :plant)
                    .references(:done_tasks)
                    .order(:order)
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
    return true if begin_date.nil?
    return true if end_date.nil?

    this_day  = Date.today.change(year: 1)
    this_day2 = Date.today.change(year: 2)

    current_done_task.nil? &&
    (( begin_date <= this_day && end_date >= this_day) || (begin_date <= this_day2 && end_date >= this_day2))
  end
end
