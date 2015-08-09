class AddPhFromToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :ph_to, :float
    rename_column :plants, :ph, :ph_from
  end
end
