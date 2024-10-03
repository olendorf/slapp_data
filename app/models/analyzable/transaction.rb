# frozen_string_literal: true

module Analyzable
  # Model for inworld transactions
  class Transaction < ApplicationRecord
    belongs_to :user
    belongs_to :abstract_web_object

    enum :transaction_type, {
      other: 0,
      account: 1
    }
  end
end
