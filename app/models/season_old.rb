class SeasonOld < ApplicationRecord
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

  def self.current
    self.season_for(Date.today)
  end

  def self.season_for(date, region=0)
    season = self.where('start <= ? and stop >= ?', date, date).where(region: region).first
    if season.nil?
      old_date = Date.new(1990, date.month, date.day)
      season = self.where('start <= ? and stop >= ?', old_date, old_date).where(region: region).first
    end
    season
  end

  def season_index
    Season.seasons[self.season]
  end
end
