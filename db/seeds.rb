# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

plant = Plant.create([{ name: 'Erdbeere', desc: 'Die Erdbeere ist eine Pflanze'}])
Task.create(title: 'Ernten', start: 2, end: 5, plant_id: plant.first.id)
