class RemoveDoneTasksUser < ActiveRecord::Migration
  def change
    remove_column :done_tasks, :user_id
  end
end
