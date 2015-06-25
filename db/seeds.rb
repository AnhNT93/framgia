# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "Nguyen Tuan Anh",
             email: "touanain@gmail.com",
             password:              "741923",
             password_confirmation: "741923")

29.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)

end
users = User.order(:created_at).take(5)
20.times do
  title   = Faker::Lorem.sentence(1)
  body = Faker::Lorem.sentence(10)
  users.each { |user| user.entries.create!(title: title, body: body) }
end
entries = Entry.order(:created_at).take(5)
10.times do
  content = Faker::Lorem.sentence(10)
  user_id =  rand(1..30)
  entries.each{ |entry| entry.comments.create!(content: content, user_id: user_id)}
end 
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }