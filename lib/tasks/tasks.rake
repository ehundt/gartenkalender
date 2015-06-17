namespace :tasks do

  desc "Transfer season start/ends for tasks to begin_date/end_date"
  task :fix_dates => :environment do
    puts "Transfer season start/ends for tasks to begin_date/end_date"
    puts "season entries are kept."

    dates = { "0" => {  start:  Date.new(1, 2, 10),
                    stop:   Date.new(1, 3, 20) },
              "1" => {  start:  Date.new(1, 3, 20),
                    stop:   Date.new(1, 4, 20) },
              "2" => {  start:  Date.new(1, 4, 20),
                    stop:   Date.new(1, 5, 20) },
              "3" => {  start:  Date.new(1, 5, 20),
                   stop:   Date.new(1, 6, 20) },
              "4" =>   { start:  Date.new(1, 6, 20),
                   stop:   Date.new(1, 8, 1) },
              "5" =>   { start:  Date.new(1, 8, 1),
                   stop:   Date.new(1, 8, 20) },
              "6" =>   { start:  Date.new(1, 8, 20),
                   stop:   Date.new(1, 9, 20) },
              "7" =>   { start:  Date.new(1, 9, 20),
                   stop:   Date.new(1, 10, 10) },
              "8" =>   { start:  Date.new(1, 10, 10),
                   stop:   Date.new(1, 11, 1) },
              "9" =>   { start:  Date.new(1, 11, 1),
                   stop:   Date.new(1, 2, 10) }
            }

    tasks = Task.where('begin_date is null and end_date is null')
    tasks.each do |task|
      task.update_attribute(:begin_date, dates[task.start.to_s][:start])
      task.update_attribute(:end_date, dates[task.stop.to_s][:stop])
      puts "#{task.title} with id #{task.id} begin_date updated."
    end
  end
end
