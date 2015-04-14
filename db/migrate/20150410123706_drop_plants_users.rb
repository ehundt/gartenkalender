class DropPlantsUsers < ActiveRecord::Migration
  def change
    drop_table :plants_users
  end
end
