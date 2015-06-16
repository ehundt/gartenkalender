class AddBeginDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :begin_date, :date
    add_column :tasks, :end_date, :date
  end
end
