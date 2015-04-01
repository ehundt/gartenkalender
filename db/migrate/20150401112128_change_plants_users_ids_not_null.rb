class ChangePlantsUsersIdsNotNull < ActiveRecord::Migration
  def change
    change_column_null :plants_users, :plant_id, false
    change_column_null :plants_users, :user_id, false
  end
end
