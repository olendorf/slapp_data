# frozen_string_literal: true

module Analyzable
  # Model for inworld transactions
  class Transaction < ApplicationRecord
    belongs_to :user
    belongs_to :abstract_web_object, optional: true

    def self.ransackable_associations(_auth_object = nil)
      %w[abstract_web_object user]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[
        abstract_web_object_id amount balance created_at
        description id id_value previous_balance target_key
        target_name transaction_type updated_at user_id
        web_object_type
      ]
    end

    enum :transaction_type, {
      other: 0,
      account: 1,
      share: 2,
      donation: 3
    }
  end
end
