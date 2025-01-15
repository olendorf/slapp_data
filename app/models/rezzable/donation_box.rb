# frozen_string_literal: true

module Rezzable
  class DonationBox < ApplicationRecord
    acts_as :abstract_web_object

    def self.ransackable_associations(_auth_object = nil)
      %w[abstract_web_object actable user created_at]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id id_value]
    end

    def biggest_donor
      data = transactions.group(:target_name, :target_key).sum(:amount).max_by do |_k, v|
        v
      end
      { target_name: data.first.first, target_key: data.first.last, amount: data.last }
    end

    def donors
      data = transactions.group(:target_name, :target_key).sum(:amount).sort_by { |_k, v| -v }
      data.collect { |k, v| { target_name: k.first, target_key: k.last, amount: v } }
    end

    def response_data
      {
        server_id: id,
        api_key:,
        object_name:,
        object_key:,
        description:,
        url:,
        payment_schedule:,
        message:
      }
    end

    OBJECT_WEIGHT = 1
  end
end
