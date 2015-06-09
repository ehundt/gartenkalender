class AddCachedVotesToPlants < ActiveRecord::Migration
  def self.up
    add_column :plants, :cached_votes_total, :integer, :default => 0
    add_index  :plants, :cached_votes_total

    # Uncomment this line to force caching of existing votes
    Plant.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :plants, :cached_votes_total
  end
end
