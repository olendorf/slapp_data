# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
DatabaseCleaner.clean_with :truncation if Rails.env.development?

# Create an owner
owner = FactoryBot.create(:owner, avatar_name: 'Random Citizen')

5.times do |i|
  terminal = FactoryBot.build :terminal, user_id: owner.id
  terminal.save
end

10.times do |i|
  FactoryBot.create(:admin, avatar_name: "Admin_#{i} Resident")
end

100.times do |i|
  user = FactoryBot.create(:user, avatar_name: "User_#{i} Resident",
                                  account_level: rand(1..4))
  objects = rand(0..user.account_level)
  objects.times do |_i|
    web_object = FactoryBot.build :web_object
    user.web_objects << web_object
    puts user.web_object_weight
  end
  puts "acount level: #{user.account_level}: objects: #{objects} - object_weight: #{user.web_object_weight}"
end
