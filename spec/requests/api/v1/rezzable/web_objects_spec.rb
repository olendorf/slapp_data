# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::WebObjects', type: :request do
  it_behaves_like 'it has a web object API', :web_object
end
