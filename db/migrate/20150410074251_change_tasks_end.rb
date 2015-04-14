class ChangeTasksEnd < ActiveRecord::Migration
  def change
    rename_column :tasks, :end, :stop
  end
end
