# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_donation_box, aliases: [:donation_box], class: 'Rezzable::DonationBox' do
    abstract_web_object
    payment_schedule { [100, 200, 300, 400].to_json }
    message { Faker::ChuckNorris.fact }
  end
end
