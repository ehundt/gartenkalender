class AddDurationToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :duration, :integer
  end
end
