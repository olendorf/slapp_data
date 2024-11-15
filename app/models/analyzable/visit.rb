# frozen_string_literal: true

module Analyzable
  # Model for managing visit data.
  class Visit < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :traffic_cop, class_name: 'Rezzable::TrafficCop', optional: true
    has_many :detections, class_name: 'Analyzable::Detection',
                          dependent: :destroy,
                          after_add: :update_data

    def active?
      detections.last.created_at + Settings.default.traffic_cop.visit_limit.minutes > Time.now
    end

    private

    def update_data(detection)
      self.avatar_name ||= detection.avatar_name
      self.avatar_key ||= detection.avatar_key
      self.duration = detection.created_at - created_at
    end
  end
end
