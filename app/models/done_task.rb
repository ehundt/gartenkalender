class DoneTask < ActiveRecord::Base
  belongs_to :task

  enum season: Season::PHAENOLOG_SEASONS
end
