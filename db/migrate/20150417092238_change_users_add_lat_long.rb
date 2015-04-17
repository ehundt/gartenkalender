class ChangeUsersAddLatLong < ActiveRecord::Migration
  def change
    add_column :users, :latitude,  :float, null: true
    add_column :users, :longitude, :float, null: true
  end
end
