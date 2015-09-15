# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Person.create(person_type: 1, name: "Site Administrator", user_name: "admin", password:"admin")
Person.create(person_type: 2, name: "Mission Clerk", user_name: "clerk", password: "clerk")
Person.create(person_type: 3, name: "Mission Secretary", user_name: "secretary", password: "secretary")
