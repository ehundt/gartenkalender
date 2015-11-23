class AddAttachmentImageToTaskImages < ActiveRecord::Migration
  def self.up
    change_table :task_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :task_images, :image
  end
end
