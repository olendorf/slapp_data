# frozen_string_literal: true

# Base class for all rezzable objects
class AbstractWebObject < ApplicationRecord
  
  
  after_initialize :set_api_key
  after_initialize :set_pinged_at
  
  actable

  belongs_to :user, optional: true

  validates :object_name, presence: true
  validates :object_key, presence: true
  validates :region, presence: true
  validates :position, presence: true
  validates :url, presence: true
  
  def reset_to_defaults!
    self.actable.class.column_defaults.except("id").each do |k, v|
      self.actable.send("#{k}=".to_sym, v)
      self.save
      # puts self.inspect
    end
  end
      
  def response_data
      {
        api_key: self.api_key,
        object_name: self.object_name,
        description: self.description
      }
  end
  
  private
  
  def set_pinged_at
    self.pinged_at = Time.now
  end

  def set_api_key
    self.api_key ||= SecureRandom.uuid
  end
end
