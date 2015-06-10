class AddPrivateNoteToPlants < ActiveRecord::Migration
  def change
    add_column :plants, :private_notes, :text, default: ""
  end
end
