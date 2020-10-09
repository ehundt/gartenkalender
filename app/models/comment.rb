class Comment < ApplicationRecord
# TODO?  acts_as_paranoid

  belongs_to :plant
  belongs_to :user
end
