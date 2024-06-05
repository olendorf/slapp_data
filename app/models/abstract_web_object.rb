# frozen_string_literal: true

# Base model for rezzable objects
class AbstractWebObject < ApplicationRecord
  after_initialize :set_api_key

  actable

  belongs_to :user, dependent: :destroy, touch: true, required: false

  private

  def set_api_key
    self.api_key ||= SecureRandom.uuid
  end
end
