class AddSlugsToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :slug, :string, unique: true
    add_index :plants, :slug
  end
end
