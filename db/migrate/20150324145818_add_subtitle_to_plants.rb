class AddSubtitleToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :subtitle, :string
  end
end
