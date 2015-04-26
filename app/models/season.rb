class Season < ActiveRecord::Base
  PHAENOLOG_SEASONS = [ :vorfrühling, :erstfrühling, :vollfrühling,
                      :frühsommer, :hochsommer, :spätsommer,
                      :frühherbst, :vollherbst, :spätherbst,
                      :winter ]

  enum season: PHAENOLOG_SEASONS

  REGIONS = [ :deutschland ]
  enum region: REGIONS

  def self.seasons_with_mean_dates
    # for a good forecast for the next years,
    # we use the oldest entry 1990 which is actually a mean value for the years
    # between 1961 and 1990
    # region: 0 == Germany
    output = {}
    seasons = Season.where(region: 0).group(:season).order(:season).limit(Task.starts.length).select(:season, "max(start) AS start", "max(stop) AS stop")

    seasons.each do |season|
      output[season.season] = season
    end
    output
  end
end
