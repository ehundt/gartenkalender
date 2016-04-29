class DoneTask < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :task,  -> { with_deleted }
  belongs_to :plant, -> { with_deleted }

  enum skipped: ["...", :ueberspringen, :erledigt]

  default_value_for :date, DateTime.now
end
