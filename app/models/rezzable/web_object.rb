# frozen_string_literal: true

module Rezzable
  # This model is mostly for testing
  class WebObject < ApplicationRecord
    acts_as :abstract_web_object

    def self.ransackable_associations(_auth_object = nil)
      %w[abstract_web_object actable user created_at]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id id_value]
    end

    OBJECT_WEIGHT = 100
  end
end
