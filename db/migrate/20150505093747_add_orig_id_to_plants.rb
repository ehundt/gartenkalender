class AddOrigIdToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :orig_id, :integer
  end
end
