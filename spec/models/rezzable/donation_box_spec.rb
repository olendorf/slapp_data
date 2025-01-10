require 'rails_helper'

RSpec.describe Rezzable::DonationBox, type: :model do
  it_behaves_like 'a rezzable object', :donation_box, 1
end
