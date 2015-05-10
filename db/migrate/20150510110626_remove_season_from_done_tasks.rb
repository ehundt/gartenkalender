class RemoveSeasonFromDoneTasks < ActiveRecord::Migration
  def change
    remove_column :done_tasks, :season
    remove_column :done_tasks, :year
  end
end
