class DropNullConstraintForSkippedInDoneTasks < ActiveRecord::Migration
  def change
    change_column :done_tasks, :skipped, :boolean, :null => true
  end
end
