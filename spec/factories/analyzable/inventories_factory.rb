# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_inventory, aliases: [:inventory], class: 'Analyzable::Inventory' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? Faker::Name.last_name : 'Resident' }
    end
    
    inventory_name { Faker::Commerce.product_name }
    description { Faker::Movie.quote }
    owner_perms { Analyzable::Inventory::PERMS.values.sample(rand(1..4)).sum }
    next_perms { Analyzable::Inventory::PERMS.values.sample(rand(1..4)).sum }
    inventory_type { 1 }
    creator_name { "#{first_name} #{last_name}" }
    creator_key { SecureRandom.uuid }
    date_acquired { Date.today - rand(10_000)  }
  end
end
