class Task < ActiveRecord::Base
  belongs_to :plant

  phaenolog_seasons = [ :vorfrühling, :erstfrühling, :vollfrühling,
                        :frühsommer, :hochsommer, :spätsommer,
                        :frühherbst, :vollherbst, :spätherbst,
                        :winter ]
  enum start: phaenolog_seasons
  enum end:   phaenolog_seasons.map{ |s| ("ende_" + s.to_s).to_sym }
  # TODO: ganzjährig hinzufügen? in der start column? end column im frontend weglassen?
  # oder eine checkbox mit "ganzjährig"?
  enum repeat: [:täglich, :wöchentlich, :monatlich, :vierteljährlich, :halbjährlich, :jährlich]

  def self.for_user(user)
    self.where('plant_id IN (?)', user.plants.select(:id))
  end
end
