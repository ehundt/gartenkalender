class TaskImage < ActiveRecord::Base
  belongs_to :task
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>"},
                            :default_url => "/task_images/:style/missing.png",
                            :path        => '/:class/image/:id/:style/:filename'


  validates_attachment :image,
    :content_type => { :content_type => /\Aimage\/.*\Z/ },
    :size         => { :in => 0..3.megabytes },
    :file_name    => { :matches => [/png\Z/, /jpe?g\Z/, /JPE?G\Z/, /gif\Z/] }

  def plant
    Plant.find(1) #task.plant
  end
end
