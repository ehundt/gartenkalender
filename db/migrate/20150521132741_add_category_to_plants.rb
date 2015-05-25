class AddCategoryToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :category, :integer, default: 0
  end
end
