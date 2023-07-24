# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_web_object, aliases: [:web_object], class: 'Rezzable::WebObject' do
    abstract_web_object factory: %i[abstract_web_object]

    setting_one { Faker::Lorem.word }
    setting_two { rand(0..10) }
  end
end
