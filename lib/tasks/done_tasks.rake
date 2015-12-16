namespace :done_tasks do
  desc "Fill column plant_id in tasks rows in DB"
  task :fill_plant_ids => :environment do
    puts "Start filling the plant_id column in done_tasks table:"
    total_count = 0
    Plant.find_each do |plant|
      count = 0
      done_tasks = DoneTask.with_deleted.where("task_id in (?)", plant.tasks.pluck(:id))
      done_tasks.find_each do |dt|
        if dt.update_attribute(:plant_id, plant.id)
          count += 1
        end
      end
      total_count += count
      #puts "Plant #{plant.name}: #{count} done_tasks updated."
    end
    puts "#{total_count} done_tasks updated."
  end
end
