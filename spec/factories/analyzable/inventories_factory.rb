FactoryBot.define do
  factory :analyzable_inventory, aliases: [:inventory], class: 'Analyzable::Inventory' do
    inventory_name { Faker::Commerce.product_name }
    inventory_key { SecureRandom.uuid }
    description { Faker::Movie.quote }
    owner_perms {  Analyzable::Inventory::PERMS.values.sample(rand(1..4)).sum }
    next_perms { Analyzable::Inventory::PERMS.values.sample(rand(1..4)).sum }
    inventory_type { 1 }
    creator_name { "MyString" }
    creator_key { "MyString" }
    date_acquired { "2024-08-27 19:14:48" }
  end
end
