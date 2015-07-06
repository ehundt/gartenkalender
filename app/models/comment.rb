class Comment < ActiveRecord::Base
# TODO?  acts_as_paranoid

  belongs_to :plant
  belongs_to :user
end
