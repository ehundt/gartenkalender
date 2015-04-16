class UserConnection < ActiveRecord::Base
  belongs_to :sharing_user,    class_name: 'User'
  belongs_to :requesting_user, class_name: 'User'

  # TODO: check that there is only one entry
end
