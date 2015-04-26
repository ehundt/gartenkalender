class AddUserToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :hide, :boolean, default: false, null: false
  end
end
