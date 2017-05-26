class AddTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :type, :string, null: false, default: 'PlantTask'
  end
end
