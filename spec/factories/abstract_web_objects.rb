FactoryBot.define do
  factory :abstract_web_object do
    object_name { "MyString" }
    object_key { "MyString" }
    descriptions { "MyString" }
    region { "MyString" }
    position { "MyString" }
    url { "MyString" }
    api_key { "MyString" }
    user_id { 1 }
    actable_id { 1 }
    actable_type { "MyString" }
    pinged_at { "2023-07-13 15:24:03" }
    major_version { 1 }
    minor_version { 1 }
    patch_version { 1 }
    server_id { 1 }
  end
end
