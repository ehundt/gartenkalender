class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :plants

  has_attached_file :picture,
    :styles         => { :medium => "300x300>", :small => "100x100", :thumb => "50x50>" },
    :default_url    => "/images/:style/missing_user.png",
    :path           => '/:class/pictures/:id/:style/:filename'

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  acts_as_voter

  def admin?
    admin == 1 || false
  end

  def display_name
    if (first_name.blank? && last_name.blank?)
      "user#{self.id}"
    else
      "#{first_name} #{last_name}"
    end
  end

  def region
    # get region for user with user.latitude and user.longitude, default: 0 = Germany
    0
  end

  def created_plants(only_public=true)
    if only_public
      plants.where(creator_id: self.id).where(public: true).order(cached_votes_total: :desc)
    else
      plants.where(creator_id: self.id).order(cached_votes_total: :desc)
    end
  end
end
