# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_transaction, aliases: [:transaction], class: 'Analyzable::Transaction' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.25 ? Faker::Name.last_name : 'Resident' }
    end
    amount { rand(-5000..5000) }
    target_name { "#{first_name} #{last_name}" }
    target_key { SecureRandom.uuid }
    description { Faker::Quote.most_interesting_man_in_the_world }
  end
end
