# frozen_string_literal: true

module Rezzable
  # Model for in world Terminals that allows users to manager their accounts
  class Terminal < ApplicationRecord
    acts_as :abstract_web_object

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

    OBJECT_WEIGHT = 100
  end
end
