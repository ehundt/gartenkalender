class RenameUserConnectionsToContacts < ActiveRecord::Migration
  def change
    rename_table :user_connections, :contacts
  end
end
