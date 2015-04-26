class ChangeDatesforTasks < ActiveRecord::Migration
  def change
    drop_table :tasks

    create_table :tasks do |t|
      t.string :title
      t.integer :start, default: 0
      t.integer :stop,  default: 0
      t.text :desc
      t.integer :repeat
      t.references :plant

      t.timestamps null: false
    end

    add_index :tasks, :plant_id
  end
end
