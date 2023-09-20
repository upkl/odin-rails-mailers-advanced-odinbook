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

10.times do
  User.create(name: f_name.name,
              email: f_internet.email,
              password: f_internet.password)
end
