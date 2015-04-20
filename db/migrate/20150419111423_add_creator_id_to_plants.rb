class AddCreatorIdToPlants < ActiveRecord::Migration
  def change
    add_reference :plants, :creator, references: :users
  end
end
