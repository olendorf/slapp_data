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
FactoryBot.create(:owner, avatar_name: 'Random Citizen')

10.times do |i|
  FactoryBot.create(:admin, avatar_name: "Admin_#{i} Resident")
end

100.times do |i|
  FactoryBot.create(:user, avatar_name: "User_#{i} Resident")
end
