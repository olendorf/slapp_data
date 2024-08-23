class Rezzable::Server < ApplicationRecord    
    acts_as :abstract_web_object
    
    has_many :clients, class_name: 'AbstractWebObject', dependent: :nullify
    
    def self.ransackable_associations(_auth_object = nil)
      %w[abstract_web_object actable user created_at]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id id_value]
    end

    def response_data
      {
        api_key:,
        object_name:,
        description:
      }
    end

    OBJECT_WEIGHT = 1
end
