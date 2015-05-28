class Plant < ActiveRecord::Base
  acts_as_paranoid
  acts_as_votable

  has_many :tasks, :dependent => :destroy
  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id, validate: true

  enum category: [:keine, :blume, :obst, :gemüse, :baum, :strauch, :kaktus, :staude, :sukkulent, :kletterpflanze, :zimmerpflanze, :wasserpflanze, :gras]

  has_attached_file :main_image,
    :styles      => { :medium => "300x300>", :thumb => "100x100>" },
    :default_url => "/images/:style/missing_plant.png",
    :path        => '/:class/main_image/:id/:style/:filename'

  validates_attachment :main_image,
    :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
    :size         => { :in => 0..2.megabytes },
    :file_name    => { :matches => [/png\Z/, /jpe?g\Z/, /JPE?G\Z/, /gif\Z/] }
    # TODO: Files on the local filesystem (and in the Rails app's public directory) will be available to the internet at large. If you require access control, it's possible to place your files in a different location.
    # see https://github.com/thoughtbot/paperclip for further information!!

  accepts_nested_attributes_for :tasks, allow_destroy: true

  # searchable do
  #   text :name, boost: 5.0
  #   text :subtitle
  #   integer (:user_id), :multiple => true
  # end

  def clone_for(user)
    cloned_plant = self.dup
    cloned_plant.user_id = user.id
    cloned_plant.main_image = main_image
    cloned_plant.orig_id = id
    cloned_plant.public = false
    cloned_plant.save

    tasks.each do |task|
      cloned_task = task.dup
      cloned_task.plant_id = cloned_plant.id
      cloned_task.user_id = user.id
      cloned_task.save
    end
# TODO: do we need a creator column in tasks table?
    cloned_plant
  end

  def original
    unless orig_id.nil?
      Plant.find(orig_id)
    else
      self
    end
  end
end
