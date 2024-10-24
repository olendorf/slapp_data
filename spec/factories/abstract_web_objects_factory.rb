# frozen_string_literal: true

FactoryBot.define do
  factory :abstract_web_object do
    object_name { Faker::Hipster.words(number: rand(1..3)).join(' ') }
    object_key { SecureRandom.uuid }
    description { Faker::ChuckNorris.fact }
    region { Faker::Lorem.words(number: rand(1..3)).join(' ') }
    position do
      { x: rand(0.0000..256.000),
        y: rand(0.0000..256.000),
        z: rand(0.0000..256.000) }.to_json
    end
    shard { 'Production' }
    url do
      'https://simhost-062cce4bc972fc71a.agni.secondlife.' \
        'io:12043/cap/c8ef5673-edea-557d-f741-1aff3c2e592f'
    end
    user_id { 1 }
  end
end
