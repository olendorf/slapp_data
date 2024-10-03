# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::Servers', type: :request do
  it_behaves_like 'it has a web object API', :server

  let(:user) { FactoryBot.create :user }
  let(:server) do
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server
  end

  describe 'index' do
    let(:path) { api_rezzable_servers_path }
    before(:each) do
      24.times do |_i|
        user.web_objects << FactoryBot.build(:server)
      end
    end
    it 'should return ok status' do
      get path, headers: headers(server)
      expect(response.status).to eq 200
    end

    context '1st page' do
      it 'returns the first page' do
        get path, params: { server_page: 1 }, headers: headers(server)
        expect(JSON.parse(response.body)['data']['server_names'].size).to eq 9
      end

      it 'returns the correct data' do
        get path, params: { server_page: 1 }, headers: headers(server)

        expect(JSON.parse(response.body)['data']['server_names']).to include(
          *user.servers.limit(9).map(&:object_name)
        )
      end

      it 'returns the correct keys' do
        get path, params: { server_page: 1 }, headers: headers(server)

        expect(JSON.parse(response.body)['data']['server_keys']).to include(
          *user.servers.limit(9).map(&:object_key)
        )
      end
    end
  end
end
