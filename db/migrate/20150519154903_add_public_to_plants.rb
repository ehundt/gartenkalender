class AddPublicToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :public, :boolean, default: false, null: false
  end
end
