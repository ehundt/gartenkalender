class DoneTask < ActiveRecord::Base
  belongs_to :task

  enum season: Season::PHAENOLOG_SEASONS

  default_value_for :date, DateTime.now
  default_value_for :year, Date.today.year
end
