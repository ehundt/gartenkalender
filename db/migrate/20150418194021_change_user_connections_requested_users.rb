class ChangeUserConnectionsRequestedUsers < ActiveRecord::Migration
  def change
    rename_column :user_connections, :sharing_user_id, :requested_user_id
  end
end
