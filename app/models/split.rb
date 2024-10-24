# frozen_string_literal: true

# Model for allowing users to split income with others
class Split < ApplicationRecord
  validates_numericality_of :percent, less_than_or_equal_to: 100, greater_than: 0

  belongs_to :splittable, polymorphic: true
end
