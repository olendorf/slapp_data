# frozen_string_literal: true

# Base model for all rezzable objects. Put methods for that here.
module Rezzable
  def self.table_name_prefix
    'rezzable_'
  end
end
