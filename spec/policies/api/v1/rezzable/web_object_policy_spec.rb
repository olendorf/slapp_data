require 'rails_helper'

RSpec.describe Api::V1::Rezzable::WebObjectPolicy, type: :policy do
  it_behaves_like 'it has a rezzable policy', :web_object
end
