# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


DatabaseCleaner.clean_with :truncation if Rails.env.development?

owner = FactoryBot.create(:owner, avatar_name: "Random Citizen")

admins = FactoryBot.create_list(:admin, 5)

users = FactoryBot.create_list(:user, 100)