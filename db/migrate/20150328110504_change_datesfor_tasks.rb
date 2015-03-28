class ChangeDatesforTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :start, :integer, default: 0
    change_column :tasks, :end, :integer, default: 0
  end
end
