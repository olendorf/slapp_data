# frozen_string_literal: true

# Provides an exception for invalid payment amounts.
class InvalidPaymentException < StandardError
  def initialize(name, msg)
    super(msg)
    @name = name
    @message = msg
  end
end
