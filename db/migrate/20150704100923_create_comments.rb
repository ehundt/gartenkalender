class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string     :comment, null: false
      t.belongs_to :plant,   index: true
      t.belongs_to :user,    index: true, null: false
      t.timestamps           null: false
    end
  end
end
