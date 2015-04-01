class ChangeTasksPlantIdNotNull < ActiveRecord::Migration
  def change
    change_column_null :tasks, :plant_id, false
  end
end
