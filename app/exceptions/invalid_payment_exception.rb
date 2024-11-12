# frozen_string_literal: true

# Provides an exception for invalid payment amounts.
class InvalidPaymentException < StandardError
  def initialize(name, msg)
    @name = name
    @message = msg
    super
  end
end
