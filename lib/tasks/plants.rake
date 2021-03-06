namespace :plants do

  desc "Fix public value for plants with a different creator"
  task :fix_public => :environment do
    puts "Fixing the public value for plants with creator != user:"
    puts "must always be public=false"

    plants = Plant.where("creator_id != user_id")
    plants.find_each do |plant|
      if plant.public
        if plant.update_attribute(:public, false)
          puts "#{plant.name} (#{plant.id}) updated"
        end
      end
    end
  end

  desc "Initialize using slugs for plants"
  task :init_slugs => :environment do
    puts "Initializing slugs for users"

    Plant.find_each(&:save)
    puts "Done."
  end
end
