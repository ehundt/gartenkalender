class CreateTaskImages < ActiveRecord::Migration
  def change
    create_table :task_images do |t|
      t.string     :title
      t.string     :desc
      t.references :task

      t.timestamps null: false
    end

    add_index :task_images, :task_id
  end
end
