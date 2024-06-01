FactoryBot.define do
  factory :rezzable_web_object, aliases: [:web_object], 
                              class: 'Rezzable::WebObject' do
    abstract_web_object
  end
end
