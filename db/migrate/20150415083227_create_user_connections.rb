class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.references :requesting_user, index: true
      t.references :sharing_user,    index: true
      t.boolean    :confirmed
      t.timestamps                   null: false
    end
  end
end
