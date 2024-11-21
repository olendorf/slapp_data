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

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

def time_rand_array from = 0.0, to = Time.now, num
  times = []
  num.times do
    times += [time_rand(from, to) ]
  end
  times
end

def give_servers_to_user(user)
  rand(1..10).times do
    server = FactoryBot.build(:server, user_id: user.id)
    server.save
    rand(1..50).times do
      server.inventories << FactoryBot.build(:inventory, user_id: user.id)
    end
  end
end

def give_terminals_to_user(user, _avatars)
  rand(3..10).times do
    terminal = FactoryBot.build(:terminal)
    user.web_objects << terminal
    # give_splits(terminal, avatars)
    next unless rand > 0.1 && user.servers.size.positive?

    terminal.server_id = user.servers.sample.id
    terminal.save

    if rand > 0.1 && user.inventories.size.positive?
      terminal.inventory = user.inventories.sample
      terminal.save
    end

    
  end
end

def give_visits_to_traffic_cop(traffic_cop, avatars, visit_time = 20)
  times = time_rand_array(2.years.ago, Time.now, rand(100)).sort
  
  times.each_with_index do |time, index|
    avatar = avatars.sample
    visit = FactoryBot.build :visit, 
                avatar_name: avatar.avatar_name, 
                avatar_key: avatar.avatar_key,
                region: traffic_cop.region,
                user_id: traffic_cop.user_id,
                created_at: time
    detection_count = 0
    while rand >= 1.0/(visit_time.to_f)
      previous_detection = visit.detections.last
      detection = FactoryBot.build :detection, created_at: visit.created_at + detection_count * 30
      if previous_detection
        detection.x = detection.x + rand(-10.0..10.0)
        detection.y = detection.y + rand(-10.0..10.0)
        detection.z = detection.z + rand(-10.0..10.0)
      end 
      visit.detections << detection
      detection_count += 1
    end
    traffic_cop.visits << visit
    traffic_cop.visits.last.update_column(:updated_at, traffic_cop.visits.last.created_at + detection_count * 30)
  end
end

def give_traffic_cops_to_user(user, avatars)
  puts "Giving Traffic Cops to #{user.avatar_name}"
  rand(3..5).times do
    traffic_cop = FactoryBot.build(:traffic_cop)
    if rand < 0.7
      traffic_cop.server = user.servers.sample if user.servers.count > 0
    end
    user.web_objects << traffic_cop
    
    give_visits_to_traffic_cop(traffic_cop, avatars)
  end
end

# Create an owner
puts 'Creating Owner'
owner = FactoryBot.create(:owner, avatar_name: 'Random Citizen')
give_servers_to_user(owner)
give_terminals_to_user(owner, avatars)
give_traffic_cops_to_user(owner, avatars)
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
    # puts user.web_object_weight
  end
  
  give_traffic_cops_to_user(user, avatars)
  # puts "acount level: #{user.account_level}: objects: #{objects} - object_weight: #{user.web_object_weight}"
end
