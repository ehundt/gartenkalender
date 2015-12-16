class AddPlantToDoneTasks < ActiveRecord::Migration
  def change
    add_reference :done_tasks, :plant, index: true
  end
end
