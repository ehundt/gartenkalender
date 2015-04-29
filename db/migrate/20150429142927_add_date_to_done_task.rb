class AddDateToDoneTask < ActiveRecord::Migration
  def change
    add_column :done_tasks, :date, :datetime, null: false, default: DateTime.now
  end
end
