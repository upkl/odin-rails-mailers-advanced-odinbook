# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

USERS_COUNT = 10
FRIEND_REQUESTS_COUNT = USERS_COUNT**2 / 5
POSTS_COUNT = USERS_COUNT * 4

f_name = Faker::Name
f_internet = Faker::Internet
f_lorem = Faker::Lorem
f_quote = Faker::Quote

Like.all.each(&:delete)
Post.all.each(&:delete)
FriendRequest.all.each(&:delete)
User.all.filter { |u| u.id != 1 }.each(&:delete)

USERS_COUNT.times do
  User.create(name: f_name.name,
              email: f_internet.email,
              password: f_internet.password)
end

(1..USERS_COUNT).to_a.combination(2).to_a.sample(FRIEND_REQUESTS_COUNT).each do |u1, u2|
  r, s = [u1, u2].sample(2)
  FriendRequest.create(sender: User.find(s),
                       receiver: User.find(r),
                       status: [0, 1, 2].sample)
end

POSTS_COUNT.times do
  Post.create(user_id: rand(1..USERS_COUNT),
              title: f_quote.yoda,
              content: f_lorem.paragraphs.join("\n"))
end

Post.all.each do |p|
  (1..USERS_COUNT).reject { |u| u == p.user_id }.sample(rand(USERS_COUNT)).each do |u|
    p.likes.create(user_id: u)
  end
end
