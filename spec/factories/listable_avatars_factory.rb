# frozen_string_literal: true

FactoryBot.define do
  factory :listable_avatar do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.25 ? Faker::Name.last_name : 'Resident' }
    end
    avatar_name { "#{first_name} #{last_name}" }
    avatar_key { SecureRandom.uuid }
    factory :allowed do
      list_name { 'allowed' }
    end

    factory :banned do
      list_name { 'banned' }
    end
    
    factory :excluded do 
      list_name { 'excluded' }
    end 
  end
end
