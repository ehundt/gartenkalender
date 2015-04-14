class AddUserToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :user, index: true
    add_column :tasks, :hide, :boolean, default: false, null: false
  end
end
