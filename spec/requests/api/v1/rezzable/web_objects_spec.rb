# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::WebObjects' do
  let(:user) { create(:user) }

  let(:web_object) do
    web_object = build(:web_object, user_id: user.id)
    web_object.save
    web_object
  end

  before do
    9.times do
      web_object = build(:web_object, user_id: user.id)
      web_object.save
    end
  end

  describe 'GET' do
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }

    before { get path, headers: headers(web_object) }

    it 'returns OK status' do
      expect(response).to have_http_status :ok
    end

    it 'returns a nice message' do
      expect(response.parsed_body['message']).to eq 'Success!'
    end

    it 'returns the data' do
      expect(response.parsed_body['data']['settings']).to include(
        'api_key' => web_object.api_key
      )
    end
  end

  describe 'GET/index' do
    let(:path) { api_rezzable_web_objects_path }

    before { get path, headers: headers(web_object) }

    it 'returns OK status' do
      expect(response).to have_http_status :ok
    end

    it 'returns all the user items' do
      expect(response.parsed_body['data'].size).to eq 10
    end
  end
end
