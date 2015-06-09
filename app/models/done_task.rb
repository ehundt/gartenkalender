class DoneTask < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :task, -> { with_deleted }

  enum season: Season::PHAENOLOG_SEASONS

  default_value_for :date, DateTime.now
end
