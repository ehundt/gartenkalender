class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :plants

  def admin?
    admin == 1 || false
  end

  def username
    if (first_name && last_name)
      status = "#{first_name} #{last_name}"
    else
      status = email
    end
  end
end
