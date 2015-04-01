class AddActiveToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :active, :boolean, null: false, default: true
  end
end
