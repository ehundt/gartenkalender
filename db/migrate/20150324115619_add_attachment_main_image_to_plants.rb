class AddAttachmentMainImageToPlants < ActiveRecord::Migration
  def self.up
    change_table :plants do |t|
      t.attachment :main_image
    end
  end

  def self.down
    remove_attachment :plants, :main_image
  end
end
