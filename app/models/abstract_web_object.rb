# frozen_string_literal: true

# Base class for all rezzable objects
class AbstractWebObject < ApplicationRecord
  actable

  belongs_to :user, optional: true

  validates :object_name, presence: true
  validates :object_key, presence: true
  validates :region, presence: true
  validates :position, presence: true
  validates :url, presence: true

  def settings
    attributes.merge(actable.attributes).except(
      'user_id', 'created_at', 'updated_at', 'actable_id', 'actable_type',
      'id', 'pinged_at'
    )
  end
end
