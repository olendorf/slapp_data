require 'rails_helper'

RSpec.describe "Api::V1::Rezzable::Servers", type: :request do
  it_behaves_like 'it has a web object API', :server
end
