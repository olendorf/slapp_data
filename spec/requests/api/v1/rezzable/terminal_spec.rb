# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::WebObjects', type: :request do
  it_behaves_like 'it has an owner API', :terminal

  describe 'giving inventory' do
    let(:owner) { FactoryBot.create :owner }
    let(:user) { FactoryBot.create :user }
    let(:server) do
      server = FactoryBot.build :server, user_id: owner.id
      server.save
      server
    end
    let(:inventory) do
      FactoryBot.create :inventory, user_id: user.id, server_id: server.id
    end
    let(:terminal) do
      terminal = FactoryBot.build :terminal, user_id: owner.id, server_id: server.id,
                                             inventory_id: inventory.id
      terminal.save
      terminal
    end

    let(:give_regex) do
      %r{https://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}/inventory/
      give\?auth_digest=[-a-f0-9]+&auth_time=[0-9]+}x
    end

    describe 'giving the user the system objects' do
      let(:path) { give_api_rezzable_terminal_path(terminal) }

      let(:atts) do
        {
          avatar_name: user.avatar_name,
          avatar_key: user.avatar_key
        }
      end

      it 'should return ok status' do
        put path, params: atts.to_json, headers: headers(terminal)
        expect(response).to have_http_status(:ok)
      end

      it 'should make the request' do
        stub = stub_request(:post, give_regex)
        put path, params: atts.to_json, headers: headers(terminal)
        expect(stub).to have_been_made
      end
    end
  end
end
