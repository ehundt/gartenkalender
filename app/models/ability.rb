class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :manage, User, :id => user.id
      can :read,   User
      can :download_picture, User

      can :manage, Plant, :user_id => user.id
      can :read,   Plant, :public  => true
      can :vote,   Plant, :public  => true
      can :clone,  Plant, :public  => true
      can :download_main_image, Plant, :user_id => user.id
      can :download_main_image, Plant, :creator_id => user.id
      can :download_main_image, Plant, :public => true

      can :new, Task
      can :create, Task
      can :manage, Task, :plant => { :user_id => user.id }
      can :read,   Task, :plant => { :public => true }

      can :create, DoneTask
      can :manage, DoneTask, :task => { :plant => { :user_id => user.id } }

      can :read, Startpage
      can :read, :static_pages
      can :help, :page
    end
  end
end
