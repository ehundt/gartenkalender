class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    friend_ids = user.friends.collect { |friend| friend.id }

    if user.admin?
      can :manage, :all
    else
      can :manage, User, :id => user.id
      can :read,   User, :id => friend_ids

      can :manage, Plant, :user_id    => user.id
      can :read,   Plant, :creator_id => friend_ids
      can :vote,   Plant, :creator_id => friend_ids
      can :clone,  Plant, :creator_id => friend_ids

      can :new, Task
      can :create, Task
      can :manage, Task, :plant => { :user_id => user.id }
      can :read,   Task, :plant => { :user_id => friend_ids }

      can :create, DoneTask
      can :manage, DoneTask, :task => { :plant => { :user_id => user.id } }

      can :manage, Contact, requesting_user_id: user.id
      can :manage, Contact, requested_user_id: user.id

      can :read, Startpage
      can :read, :static_pages
    end
  end
end
