# frozen_string_literal: true

module Analyzable
  # Model for managing visit data.
  class Visit < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :traffic_cop, class_name: 'Rezzable::TrafficCop', optional: true
    has_many :detections, class_name: 'Analyzable::Detection',
                          dependent: :destroy,
                          after_add: :update_data

    def self.ransackable_associations(_auth_object = nil)
      %w[detections traffic_cop user]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[avatar_key avatar_name created_at duration id id_value region traffic_cop_id updated_at
         user_id]
    end

    def active?
      detections.last.created_at + Settings.default.traffic_cop.visit_limit.minutes > Time.now
    end

    private

    def update_data(detection)
      self.avatar_name ||= detection.avatar_name
      self.avatar_key ||= detection.avatar_key
      self.duration = detection.created_at - created_at
      save
      logger.debug "self created at: #{created_at}\ndetecte created_at: #{detection.created_at}\nduration: #{duration}"
    end
  end
end
