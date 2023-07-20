# frozen_string_literal: true

module Rezzable
  # A test object for general web object development
  class WebObject < ApplicationRecord
    acts_as :abstract_web_object
    
    def response_data
      self.abstract_web_object.response_data.merge(
        setting_one: setting_one,
        setting_two: setting_two
        )
    end
  end
end
