class AddSkippedToDoneTasks < ActiveRecord::Migration
  def change
    add_column :done_tasks, :skipped, :boolean, null: false, default: false
  end
end
