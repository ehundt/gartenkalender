class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :plants

  has_many :requesting_contacts, class_name: 'Contact',
           foreign_key: :requested_user_id, :dependent => :destroy

  has_many :requested_contacts,  class_name: 'Contact',
           foreign_key: :requesting_user_id,  :dependent => :destroy

  accepts_nested_attributes_for :requesting_contacts, allow_destroy: true
  accepts_nested_attributes_for :requested_contacts,  allow_destroy: true

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

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

  # a friend is a confirmed contact user
  def friends
    Contact.confirmed_contacts_for(self).collect { |c| c.sharing_user_for(self) }
  end
end
