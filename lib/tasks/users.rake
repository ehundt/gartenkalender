namespace :users do

  desc "Start using slugs for users"
  task :init_slugs => :environment do
    puts "Initializing user slugs..."
    User.find_each(&:save)
    puts "Done..."
  end
end
