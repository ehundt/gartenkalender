class AddNoticeToDoneTask < ActiveRecord::Migration
  def change
    add_column :done_tasks, :notice, :string
  end
end
