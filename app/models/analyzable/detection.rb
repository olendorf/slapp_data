# frozen_string_literal: true

module Analyzable
  # Model for detections by a TrafficCop
  class Detection < ApplicationRecord
    belongs_to :visit, class_name: 'Analyzable::Visit', optional: true

    attr_accessor :avatar_name, :avatar_key
  end
end
