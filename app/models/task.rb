class Task < ApplicationRecord
  acts_as_paranoid

  belongs_to :plant
  has_many :done_tasks
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
    user.tasks.where(hide: hide).includes(:plant).references(:plant).where('plants.active = ?', true)
  end

  def self.upcoming_tasks_for_user(user)
    current_tasks = self.all_for_user(user).in_time_frame
                        .includes(:done_tasks, :plant)
                        .references(:done_tasks)
                        .order(:order)

# this is the sql that's created by the above:
# SELECT plants.name, tasks.title, done_tasks.id FROM "tasks"
# LEFT OUTER JOIN "plants"
#     ON "plants"."id" = "tasks"."plant_id"
#     AND "plants"."deleted_at" IS NULL
# LEFT OUTER JOIN "done_tasks"
#     ON "done_tasks"."task_id" = "tasks"."id"
#     AND "done_tasks"."deleted_at" IS NULL
# WHERE "tasks"."deleted_at" IS NULL
# AND "tasks"."user_id" = 1
# AND "tasks"."hide" = 'f'
# AND (plants.active = 't')
# AND (    (begin_date <= '0001-06-26' AND end_date >= '0001-06-16')
#       OR (begin_date <= '0002-06-26' AND end_date >= '0002-06-16'))
# ORDER BY "tasks"."order" ASC

    upcoming_tasks = []
    current_tasks.each do |task|
      upcoming_tasks.push(task) unless (task.done? || task.skipped?)
    end
    upcoming_tasks
  end

  def current_done_tasks
    current_done_tasks = case repeat
      when "einmalig"     then single_done_tasks
      when "jährlich"     then yearly_done_tasks
      when "täglich"      then daily_done_tasks
      when "wöchentlich"  then weekly_done_tasks
      when "monatlich"    then monthly_done_tasks
      when "halbjährlich" then half_yearly_done_tasks
    end
    current_done_tasks
  end

  def single_done_tasks
    if done_tasks.empty?
      []
    else
      done_tasks
    end
  end

  def yearly_done_tasks
    current_done_tasks = []
    done_tasks.each do |done_task|
      current_done_tasks.push(done_task) if done_task.date.year == Date.today.year
      # TODO: not correct in winter!!
    end
    return current_done_tasks
  end

  def daily_done_tasks
    current_done_tasks = []
    done_tasks.each do |done_task|
      current_done_tasks.push(done_task) if done_task.date.to_date == Date.today
    end
    return current_done_tasks
  end

  def weekly_done_tasks
    current_done_tasks = []
    done_tasks.each do |done_task|
      current_done_tasks.push(done_task) if done_task.date + 7.days >= Date.today
    end
    return current_done_tasks
  end

  def monthly_done_tasks
    current_done_tasks = []
    done_tasks.each do |done_task|
      current_done_tasks.push(done_task) if done_task.date + 1.month >= Date.today
    end
    return current_done_tasks
  end

  def half_yearly_done_tasks
    current_done_tasks = []
    done_tasks.each do |done_task|
      current_done_tasks.push(done_task) if done_task.date + 6.months >= Date.today
    end
    return current_done_tasks
  end

  def done?
    return false if current_done_tasks.empty?

    current_done_tasks.each do |dt|
      return true if dt.skipped == "erledigt"
    end
    return false
  end

  def skipped?
    return false if current_done_tasks.empty?

    current_done_tasks.each do |dt|
      return true if dt.skipped == "ueberspringen"
    end
    return false
  end

  def upcoming?
    return true if begin_date.nil?
    return true if end_date.nil?

    this_day  = Date.today.change(year: 1)
    this_day2 = Date.today.change(year: 2)

    !done? && !skipped? &&
    ((( begin_date <= this_day) && (end_date >= this_day - 10.days)) || ((begin_date <= this_day2) && (end_date >= this_day2 - 10.days)))
  end
end
