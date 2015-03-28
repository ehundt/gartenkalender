class CreatePlantsUsers < ActiveRecord::Migration
  def change
    create_table :plants_users, id: false do |t|
      t.belongs_to :plant, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
