FactoryBot.define do
  factory :rezzable_server, aliases: [:server], class: 'Rezzable::Server' do
    abstract_web_object
    
  end
end
