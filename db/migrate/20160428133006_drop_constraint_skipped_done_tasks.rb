class DropConstraintSkippedDoneTasks < ActiveRecord::Migration
  def self.up
    add_column :done_tasks, :temp_skipped, :integer

    DoneTask.reset_column_information

    DoneTask.find_each do |done_task|
      if done_task.skipped
        done_task.temp_skipped = 1
      else
        done_task.temp_skipped = 2
      end
      done_task.save
    end

    remove_column :done_tasks, :skipped
    rename_column :done_tasks, :temp_skipped, :skipped
  end
end
