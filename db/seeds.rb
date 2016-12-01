# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Seeding Data ...'

puts 'Re-creating Users ...'

# User.destroy_all

user1 = User.create!(first_name: 'TAE', last_name: 'Kim', email: 'ty2kim@example.com', password: '123456', password_confirmation: '123456')
# user2 = User.create!(first_name: 'Bob', last_name: 'B', email: 'bob@example.com', password: '1', password_confirmation: '1')

puts 'Re-creating Preferences ...'

# Preference.destroy_all

# Preference.create!(user_id: user1.id, route: '258-MI', route_variant: 'MI', from_stop: 'UN', to_stop: 'SR')
puts 'DONE!'
