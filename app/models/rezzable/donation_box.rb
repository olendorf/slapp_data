class Rezzable::DonationBox < ApplicationRecord
  acts_as :abstract_web_object
  
  def self.ransackable_associations(_auth_object = nil)
    %w[abstract_web_object actable user created_at]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id id_value]
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
