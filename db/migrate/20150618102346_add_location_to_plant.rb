class AddLocationToPlant < ActiveRecord::Migration
  def change
    add_column :plants, :location, :string
    add_column :plants, :soil, :string
    add_column :plants, :ph, :float
  end
end
