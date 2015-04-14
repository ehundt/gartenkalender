class CreateDoneTasks2 < ActiveRecord::Migration
  def change
    create_table :done_tasks do |t|
      t.belongs_to :task, index: true
      t.integer    :season, null: false
      t.integer    :year,   null: false
      t.timestamps          null: false
    end
  end
end
