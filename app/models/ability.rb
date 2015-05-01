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

      can :manage, Plant, :user_id => user.id
      can :read, Plant,   :creator_id => friend_ids

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

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
