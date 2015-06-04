# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Season.create([{ season: :vorfrühling,
                 start:  Date.new(1990, 2, 14),
                 stop:   Date.new(1990, 3, 21),
                 region: :deutschland },
               { season: :erstfrühling,
                 start:  Date.new(1990, 3, 22),
                 stop:   Date.new(1990, 4, 26),
                 region: :deutschland },
               { season: :vollfrühling,
                 start:  Date.new(1990, 4, 27),
                 stop:   Date.new(1990, 5, 25),
                 region: :deutschland },
               { season: :frühsommer,
                 start:  Date.new(1990, 5, 26),
                 stop:   Date.new(1990, 6, 18),
                 region: :deutschland },
               { season: :hochsommer,
                 start:  Date.new(1990, 6, 19),
                 stop:   Date.new(1990, 7, 31),
                 region: :deutschland },
               { season: :spätsommer,
                 start:  Date.new(1990, 8, 1),
                 stop:   Date.new(1990, 8, 21),
                 region: :deutschland },
               { season: :frühherbst,
                 start:  Date.new(1990, 8, 22),
                 stop:   Date.new(1990, 9, 19),
                 region: :deutschland },
               { season: :vollherbst,
                 start:  Date.new(1990, 9, 20),
                 stop:   Date.new(1990, 10, 16),
                 region: :deutschland },
               { season: :spätherbst,
                 start:  Date.new(1990, 10, 17),
                 stop:   Date.new(1990, 11, 3),
                 region: :deutschland },
               { season: :winter,
                 start:  Date.new(1990, 11, 4),
                 stop:   Date.new(1991, 2, 13),
                 region: :deutschland },
              ])
