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

avatars = FactoryBot.create_list(:avatar, 100)

def give_servers_to_user(user)
  rand(1..10).times do
    server = FactoryBot.build(:server, user_id: user.id)
    server.save
    rand(1..50).times do
      server.inventories << FactoryBot.build(:inventory)
    end
  end
end

def give_terminals_to_user(user, _avatars)
  rand(3..10).times do
    terminal = FactoryBot.build(:terminal)
    user.web_objects << terminal
    # give_splits(terminal, avatars)
    if rand > 0.1 && user.servers.size.positive?
      terminal.server_id = user.servers.sample.id
      terminal.save
    end

    # rand(1..50).times do
    # end
  end
end

# Create an owner
puts 'Creating Owner'
owner = FactoryBot.create(:owner, avatar_name: 'Random Citizen')
give_servers_to_user(owner)
give_terminals_to_user(owner, avatars)
# 3.times do
#   server = FactoryBot.build :server
#   owner.web_objects << server
# end

# 5.times do |_i|
#   server = owner.servers.sample
#   terminal = FactoryBot.build :terminal, user_id: owner.id, server_id: server.id
#   terminal.save
# end

10.times do |i|
  FactoryBot.create(:admin, avatar_name: "Admin_#{i} Resident")
end

100.times do |i|
  user = FactoryBot.create(:user, avatar_name: "User_#{i} Resident",
                                  account_level: rand(1..5))
  puts "Creating user: #{user.avatar_name}"
  objects = rand(0..user.account_level - 1)
  give_servers_to_user(user)
  objects.times do
    server = user.servers.sample
    web_object = FactoryBot.build :web_object, server_id: server.id
    user.web_objects << web_object
    puts user.web_object_weight
  end
  # puts "acount level: #{user.account_level}: objects: #{objects} - object_weight: #{user.web_object_weight}"
end
