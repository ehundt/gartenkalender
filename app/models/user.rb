class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :plants
  has_many :requesting_users, class_name: 'UserConnection', foreign_key: :requesting_user_id, :dependent => :destroy
  has_many :sharing_users,    class_name: 'UserConnection', foreign_key: :sharing_user_id, :dependent => :destroy

  accepts_nested_attributes_for :requesting_users, allow_destroy: true
  accepts_nested_attributes_for :sharing_users, allow_destroy: true

  def admin?
    admin == 1 || false
  end

  def display_name
    if (first_name && last_name)
      status = "#{first_name} #{last_name}"
    else
      status = email
    end
  end
end
