class DropDoneTasks < ActiveRecord::Migration
  def change
    drop_table :done_tasks
  end
end
