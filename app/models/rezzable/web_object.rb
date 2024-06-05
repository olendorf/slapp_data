# frozen_string_literal: true

module Rezzable
  # This model is mostly for testing
  class WebObject < ApplicationRecord
    acts_as :abstract_web_object
  end
end
