class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :season, null: false
      t.date    :start,  null: false
      t.date    :stop,   null: false
      t.integer :region, null: false
      t.timestamps       null: false
    end
  end
end
