require 'rails_helper'

RSpec.describe "Api::V1::Rezzable::DonationBoxes", type: :request do
  it_behaves_like 'it has a web object API', :donation_box
end
