# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.25 ? Faker::Name.last_name : 'Resident' }
    end
    avatar_name { "#{first_name} #{last_name}" }
    avatar_key { SecureRandom.uuid }
    password { 'Pa$$word123' }
    password_confirmation { 'Pa$$word123' }
    role { 0 }
    expiration_date { 1.week.from_now }

    factory :admin do
      role { 1 }
    end

    factory :owner do
      role { 2 }
    end
  end
end
