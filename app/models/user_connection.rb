class UserConnection < ActiveRecord::Base
  belongs_to :requesting_user, class_name: 'User'
  belongs_to :requested_user,  class_name: 'User'

  scope :confirmed, ->{ where(confirmed: true) }
  # TODO: check that there is only one entry

  def self.confirmed_connections_for(user)
    requested = user.requested_connections.confirmed.to_a
    requesting = user.requesting_connections.confirmed.to_a
    requesting + requested
  end

  def sharing_user_for(user)
    if requested_user == user
      requesting_user
    else
      requested_user
    end
  end
end
