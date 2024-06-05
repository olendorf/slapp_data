# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::WebObjects', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:web_object) do
    web_object = FactoryBot.build(:web_object)
    web_object.save
    user.web_objects << web_object
    web_object
  end
  describe 'GET' do
    context 'valid request' do
      let(:path) { api_rezzable_web_object_path(web_object.object_key) }

      it 'should return ok status' do
        get path, headers: headers(web_object)
        expect(response).to have_http_status(:ok)
      end

      it 'should return the correct data' do
        get path, headers: headers(web_object)
        # puts JSON.parse(response.body)['data']
        expect(JSON.parse(response.body).with_indifferent_access['data']).to include(
          object_key: web_object.object_key,
          object_name: web_object.object_name,
          owner_name: web_object.owner_name,
          owner_key: web_object.owner_key
        )
      end

      it 'should not return secret data' do
        get path, headers: headers(web_object)
        # puts JSON.parse(response.body)['data']
        expect(JSON.parse(response.body).with_indifferent_access['data']).to_not include(
          :id, :url, :user_id, :created_at, :updated_at
        )
      end
    end

    context 'object does not exist' do
      let(:path) { api_rezzable_web_object_path(SecureRandom.uuid) }

      it 'should return not_found status' do
        get path, headers: headers(web_object)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'CREATE' do
    let(:path) { api_rezzable_web_objects_path }

    it 'should return created status' do
      new_object = FactoryBot.build :web_object, api_key: Settings.default.api_key
      object_params = { url: 'https://example.com/' }
      post path, params: object_params.to_json, headers: headers(new_object)
      expect(response).to have_http_status(:created)
    end

    it 'should create the web_object' do
      new_object = FactoryBot.build :web_object, api_key: Settings.default.api_key
      object_params = { url: 'https://example.com/' }
      expect do
        post path,
             params: object_params.to_json,
             headers: headers(new_object)
      end.to change { Rezzable::WebObject.count }.by(1)
    end
  end

  describe 'UPDATE' do
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }

    it 'should return OK status' do
      object_params = { url: 'https//anotherexample.com', object_name: 'new name' }
      put path, params: object_params.to_json, headers: headers(web_object)
      expect(response).to have_http_status(:ok)
    end

    it 'should update the object' do
      object_params = { url: 'https//anotherexample.com', object_name: 'new name' }
      put path, params: object_params.to_json, headers: headers(web_object)
      expect(web_object.reload.url).to eq 'https//anotherexample.com'
    end
  end

  describe 'DESTROY' do
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }

    it 'should return ok status' do
      delete path, headers: headers(web_object)
      expect(response).to have_http_status(:ok)
    end

    it 'should return a nice message' do
      delete path, headers: headers(web_object)
      expect(JSON.parse(response.body)['data']['message']).to eq 'The object has been destroyed.'
    end

    it 'should delete the object' do
      web_object
      expect { delete path, headers: headers(web_object) }
        .to change { Rezzable::WebObject.count }.by(-1)
    end
  end
end
