# frozen_string_literal: true

module Rezzable
  # Model for Donation Boxes. Allows avatars to donate to another.
  class DonationBox < ApplicationRecord
    acts_as :abstract_web_object
    
    attr_accessor :donation
    
    after_update :handle_donation!, if: :donation
    
    # accepts_nested_attributes_for :transactions, allow_destroy: true

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
      last_data = self.transactions.last
      
      {
        server_id: id,
        api_key:,
        object_name:,
        object_key:,
        description:,
        url:,
        payment_schedule:,
        message:,
        total: self.transactions.sum(:amount),
        last_tip: last_data.nil? ? nil : last_data.amount,
        last_tipper: last_data.nil? ? nil : last_data.target_name,
        biggest_donor: last_data.nil? ? nil : self.biggest_donor
      }
    end

    OBJECT_WEIGHT = 1
    
    private
    
    def handle_donation!
      data = donation.merge!({
        'description' => "Donation from #{donation['target_name']}",
        'abstract_web_object_id' => self.abstract_web_object.id,
        'transaction_type' => :donation,
        'web_object_type' => 'donation_box'
        })
      # donation = donation.merge({
      #   'user_id' => self.user.id,
      #   # 'description' => "Donation from #{donation['target_name']}",
      #   'transaction_type' => :donation,
      #   'web_object_type' => 'donation_box'
      # })
      self.donation = nil
      self.user.transactions << Analyzable::Transaction.new(data)
      # puts self.transactions.last.inspect
    end 
  end
end
