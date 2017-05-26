class RenamePlants < ActiveRecord::Migration
def self.up
    rename_table :plants, :organisms
    add_column :organisms, :type, :string, null: false, default: 'Plant'
  end

  def self.down
    rename_table :organisms, :plants
    remove_column :plants, :type
  end
end
