# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Group.create([{ priority: 1, name: :admin }, { priority: 9, name: :standard }, { priority: 99, name: :guest }])
user = User.new
user.email = 'admin@vortrics.com'
user.name = 'Admin'
user.password = ENV[:ADMIN_PASSWORD.to_s]
user.password_confirmation = ENV[:ADMIN_PASSWORD.to_s]
user.save!
Access.create ([{ user_id: User.find_by_name('Admin').id, group_id: Group.find_by_priority(1).id }])

