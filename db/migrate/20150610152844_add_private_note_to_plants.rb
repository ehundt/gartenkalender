class AddPrivateNoteToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :private_notes, :string
  end
end
