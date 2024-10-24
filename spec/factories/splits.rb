# frozen_string_literal: true

FactoryBot.define do
  factory :split do
    percent { 1 }
    target_key { 'MyString' }
    target_name { 'MyString' }
    splittable_id { 1 }
    splittable_type { 'MyString' }
  end
end
