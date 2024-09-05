# frozen_string_literal: true

module Rezzable
  # Model for in world servers that handle inventory giving.
  class Server < ApplicationRecord
    acts_as :abstract_web_object

    has_many :clients, class_name: 'AbstractWebObject', dependent: :nullify

    has_many :inventories, class_name: 'Analyzable::Inventory',
                           dependent: :destroy,
                           before_add: :assign_user_to_inventory
                           
                           
    accepts_nested_attributes_for :inventories, allow_destroy: true

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

    private

    def assign_user_to_inventory(inventory)
      inventory.user_id = user.id
    end
  end
end
