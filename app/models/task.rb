class Task < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :plant
  has_many :done_tasks
  has_many :skipped_tasks, -> {where(skipped: true)}, class_name: "DoneTask"
  has_many :task_images, :dependent => :destroy

  enum repeat: [:einmalig, :täglich, :wöchentlich, :monatlich, :halbjährlich, :jährlich]

  validates :title, presence: true

  accepts_nested_attributes_for :task_images,
                                :reject_if => lambda { |t| t['task_image'].nil? }

  scope :in_time_frame, -> {
    search_for_date = Date.today.change(year: 1)
    search_for_date2 = Date.today.change(year: 2)

    where('(begin_date <= ? AND end_date >= ?) OR (begin_date <= ? AND end_date >= ?)',
          search_for_date, search_for_date - 10.days, search_for_date2, search_for_date2 - 10.days)
  }

  def self.all_for_user(user, hide=false)
    self.where(hide: hide).where('plant_id IN (?)', user.plants.where(active: true).select(:id))
  end

  def self.upcoming_tasks_for_user(user)

    current_tasks = self.all_for_user(user).in_time_frame
                    .includes(:done_tasks, :plant)
                    .references(:done_tasks)
                    .order(:order)

# this is the sql that's created by the above ... performant??
# I only need the tasks from active plants...

#  SELECT ... FROM "tasks"
#  LEFT OUTER JOIN "done_tasks"
#              ON "done_tasks"."task_id" = "tasks"."id"
#              AND "done_tasks"."deleted_at" IS NULL
#  LEFT OUTER JOIN "plants" ON "plants"."id" = "tasks"."plant_id"
#             AND "plants"."deleted_at" IS NULL
#
#  WHERE "tasks"."deleted_at" IS NULL
#  AND "tasks"."hide" = 'f'
#  AND (plant_id IN
#         (SELECT "plants"."id" FROM "plants"
#             WHERE "plants"."deleted_at" IS NULL
#             AND "plants"."user_id" = 4
#             AND "plants"."active" = 't'))
#  AND ( ( begin_date <= '0001-10-13'
#         AND end_date >= '0001-10-03')
#      OR ( begin_date <= '0002-10-13'
#           AND end_date >= '0002-10-03'))

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
