class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.string :image_url
      t.text :desc

      t.timestamps
    end
  end

end
