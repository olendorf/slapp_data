# frozen_string_literal: true

module Rezzable
  # This model is mostly for testing
  class WebObject < ApplicationRecord
    acts_as :abstract_web_object
    
    def self.ransackable_associations(auth_object = nil)
      ["abstract_web_object", "actable", "user", "created_at"]
    end
    
    def self.ransackable_attributes(auth_object = nil)
      ["id", "id_value"]
    end

    OBJECT_WEIGHT = 100
  end
end
