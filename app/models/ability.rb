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
      can :vote,   Plant
      can :unvote, Plant
      can :clone,  Plant, :public  => true
      can :download_main_image, Plant, :user_id => user.id
      can :download_main_image, Plant, :creator_id => user.id
      can :download_main_image, Plant, :public => true

      can :new, Task
      can :create, Task
      can :manage, Task, :plant => { :user_id => user.id }
      can :read,   Task, :plant => { :public => true }

      can :create,              TaskImage
      can :update,              TaskImage, :task => { :user_id => user.id }
      can :destroy,             TaskImage, :task => { :user_id => user.id }
      can :download_task_image, TaskImage, :task => { :user_id => user.id }
      can :download_task_image, TaskImage, :task => { :plant => { :public => true } }

      can :create, DoneTask
      can :manage, DoneTask, :plant => { :user_id => user.id }

      can :read, Startpage
      can :entry, Startpage
      can :first_steps, Startpage
      can :welcome, Startpage
      can :read, :static_pages
      can :help, :page

      can :read, Comment
      can :create, Comment
      can :manage, Comment, :user_id => user.id
    end
  end
end
