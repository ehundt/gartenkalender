class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :start
      t.string :end
      t.text :desc
      t.integer :repeat
      t.references :plant

      t.timestamps null: false
    end

    add_index :tasks, :plant_id
  end
end
