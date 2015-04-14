class DropTasksUser < ActiveRecord::Migration
  def change
    remove_column :tasks, :user
  end
end
