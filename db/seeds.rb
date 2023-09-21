# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

f_name = Faker::Name
f_internet = Faker::Internet
f_lorem = Faker::Lorem
f_quote = Faker::Quote

Post.all.each { |p| p.delete }
FriendRequest.all.each { |r| r.delete }
User.all.filter { |u| u.id != 1 }.each { |u| u.delete }

10.times do
  User.create(name: f_name.name,
              email: f_internet.email,
              password: f_internet.password)
end

(1..10).to_a.combination(2).to_a.sample(20).each do |u1, u2|
  r, s = [u1, u2].sample(2)
  FriendRequest.create(sender: User.find(s),
                       receiver: User.find(r),
                       status: [0, 1, 2].sample)
end

30.times do
  Post.create(user_id: (1..10).to_a.sample,
              title: f_quote.yoda,
              content: f_lorem.paragraphs.join("\n"))
end
