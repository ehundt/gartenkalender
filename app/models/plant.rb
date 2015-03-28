class Plant < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_and_belongs_to_many :users

  has_attached_file :main_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :main_image,
    :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
    :size         => { :in => 0..2.megabytes },
    :file_name    => { :matches => [/png\Z/, /jpe?g\Z/] }
    # TODO: Files on the local filesystem (and in the Rails app's public directory) will be available to the internet at large. If you require access control, it's possible to place your files in a different location.
    # see https://github.com/thoughtbot/paperclip for further information!!

  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: false ### TODO: correct?
end
