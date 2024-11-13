FactoryBot.define do
  factory :analyzable_detection, class: 'Analyzable::Detection' do
    x { rand(0.0..256.0) }
    y { rand(0.0..256.0)  }
    z { rand(0.0..4096.0) }
  end
end
