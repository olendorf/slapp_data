# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_detection, aliases: [:detection], class: 'Analyzable::Detection' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.25 ? Faker::Name.last_name : 'Resident' }
    end
    avatar_name { "#{first_name} #{last_name}" }
    avatar_key { SecureRandom.uuid }
    x { rand(0.0..256.0) }
    y { rand(0.0..256.0)  }
    z { rand(0.0..4096.0) }
  end
end
