# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::TrafficCops', type: :request do
  it_behaves_like 'it has a web object API', :traffic_cop

  let(:user) { FactoryBot.create :user }
  let(:server) do
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server.inventories << FactoryBot.build(:inventory)
    server
  end
  let(:traffic_cop) do
    traffic_cop = FactoryBot.build :traffic_cop, user_id: user.id, server_id: server.id
    traffic_cop.save
    traffic_cop
  end

  let(:give_regex) do
    %r{https://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}/inventory/
    give\?auth_digest=[-a-f0-9]+&auth_time=[0-9]+}x
  end

  describe 'detection requests' do
    let(:detections) { FactoryBot.attributes_for_list :detection, 3 }
    let(:path) { api_rezzable_traffic_cop_path(traffic_cop) }
    let(:attributes) { { detections: } }

    it 'should return ok status' do
      put path, params: attributes.to_json, headers: headers(traffic_cop)
      expect(response).to have_http_status(:ok)
    end

    it 'should return the correct response message keys' do
      put path, params: attributes.to_json, headers: headers(traffic_cop)
      expect(JSON.parse(response.body)['data']['outgoing_messages']['first_visit'])
        .to eq(detections.collect { |d| d[:avatar_key] })
    end

    it 'should return the correct messages' do
      put path, params: attributes.to_json, headers: headers(traffic_cop)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']).to include(
        'first_visit_message' => traffic_cop.first_visit_message,
        'repeat_visit_message' => traffic_cop.repeat_visit_message,
        'banned_message' => traffic_cop.banned_message
      )
    end

    it 'should give inventory when its set' do
      traffic_cop.inventory_id = server.inventories.first.id
      traffic_cop.save
      put path, params: attributes.to_json, headers: headers(traffic_cop)
      stub = stub_request(:post, give_regex)
      expect(stub).to have_been_made
    end
  end

  describe 'adding listable avatars' do
    let(:path) { api_rezzable_traffic_cop_path(traffic_cop) }
    context 'banned avatars' do
      let(:atts) do
        { listable_avatars_attributes: [FactoryBot.attributes_for(:banned)] }
      end
      it 'should return OK status' do
        put path, params: atts.to_json, headers: headers(traffic_cop)
        expect(response).to have_http_status(:ok)
      end

      it 'should add the listable avatar' do
        expect do
          put path, params: atts.to_json, headers: headers(traffic_cop)
        end.to change(traffic_cop.banned, :count).by(1)
      end
    end

    context 'allowed avatars' do
      let(:atts) do
        { listable_avatars_attributes: [FactoryBot.attributes_for(:allowed)] }
      end
      it 'should return OK status' do
        put path, params: atts.to_json, headers: headers(traffic_cop)
        expect(response).to have_http_status(:ok)
      end

      it 'should add the listable avatar' do
        expect do
          put path, params: atts.to_json, headers: headers(traffic_cop)
        end.to change(traffic_cop.allowed, :count).by(1)
      end
    end
  end

  describe 'removing listable avatars' do
    let(:path) { api_rezzable_traffic_cop_path(traffic_cop) }
  end
end
