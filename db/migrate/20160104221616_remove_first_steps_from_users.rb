class RemoveFirstStepsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_steps_seen
  end
end
