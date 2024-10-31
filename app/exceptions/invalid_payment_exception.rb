
 
class InvalidPaymentException < StandardError
  def initialize(name, msg)
    @name = name
    @message = msg
  end
end