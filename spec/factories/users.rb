# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? Faker::Name.last_name : 'Resident' }
    end
    sequence(:avatar_name) { |n| "#{first_name}#{n} #{last_name}" }
    avatar_key { SecureRandom.uuid }
    password { 'Pa$sW0rd' }

    factory :admin do
      role { :admin }
    end

    factory :owner do
      role { :owner }
    end
  end
end
