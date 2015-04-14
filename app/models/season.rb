class Season < ActiveRecord::Base
  PHAENOLOG_SEASONS = [ :vorfrühling, :erstfrühling, :vollfrühling,
                      :frühsommer, :hochsommer, :spätsommer,
                      :frühherbst, :vollherbst, :spätherbst,
                      :winter ]

  enum season: PHAENOLOG_SEASONS
end
