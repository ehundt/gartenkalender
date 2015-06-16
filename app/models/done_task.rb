class DoneTask < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :task, -> { with_deleted }

  default_value_for :date, DateTime.now
end
