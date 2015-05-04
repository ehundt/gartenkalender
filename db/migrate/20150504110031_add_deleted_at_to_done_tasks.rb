class AddDeletedAtToDoneTasks < ActiveRecord::Migration
  def change
    add_column :done_tasks, :deleted_at, :datetime
    add_index :done_tasks, :deleted_at
  end
end
