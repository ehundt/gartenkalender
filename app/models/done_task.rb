class DoneTask < ActiveRecord::Base
  belongs_to :task

  enum season: Task::PHAENOLOG_SEASONS
end
