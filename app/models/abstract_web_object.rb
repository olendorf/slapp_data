# frozen_string_literal: true

# Base model for rezzable objects
class AbstractWebObject < ApplicationRecord
  after_initialize :set_api_key
  before_destroy :decrement_user_caches
  

  actable

  belongs_to :user, dependent: :destroy, touch: true, required: false
  
  def object_weight
    actable.class::OBJECT_WEIGHT
  end
  
  def decrement_user_caches
    user.web_object_count -= 1
    user.web_object_weight -= object_weight
  end 

  private

  def set_api_key
    self.api_key ||= SecureRandom.uuid
  end
end
