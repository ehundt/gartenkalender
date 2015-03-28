class Task < ActiveRecord::Base
  belongs_to :plant

  phaenolog_seasons = [ :ganzjährig,
                        :vorfrühling, :erstfrühling, :vollfrühling,
                        :frühsommer, :hochsommer, :spätsommer,
                        :frühherbst, :vollherbst, :spätherbst,
                        :winter ]
  enum start: phaenolog_seasons
  enum end:   phaenolog_seasons.map{ |s| ("ende_" + s.to_s).to_sym }
  enum repeat: [:täglich, :wöchentlich, :monatlich, :vierteljährlich, :halbjährlich, :jährlich]
end
