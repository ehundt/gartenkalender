class RemoveUserFromTasks < ActiveRecord::Migration
  def self.up
    remove_references :tasks, :user
  end

  def self.down
    add_reference :tasks, :user, index: true
  end
end
