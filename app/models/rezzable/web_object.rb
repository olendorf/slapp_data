# frozen_string_literal: true

module Rezzable
  # A test object for general web object development
  class WebObject < ApplicationRecord
    acts_as :abstract_web_object
  end
end
