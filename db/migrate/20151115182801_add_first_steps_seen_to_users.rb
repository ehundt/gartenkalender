class AddFirstStepsSeenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_steps_seen, :boolean, default: false
  end
end
