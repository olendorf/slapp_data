# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventorySlRequest do
  let(:user) { FactoryBot.create :user }
  let(:server) do 
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server
  end
  before(:each) do
    4.times do |i|
      server.inventories << FactoryBot.build(:inventory, inventory_name: "inventory #{i}")
    end
  end

  let(:uri_regex) do
    %r{https://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}/
    inventory/inventories/[a-zA-Z\s%0-9]+\?auth_digest=[-a-f0-9]+&auth_time=[0-9]+}x
  end
  let(:give_regex) do
    %r{https://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}/inventory/
    give\?auth_digest=[-a-f0-9]+&auth_time=[0-9]+}x
  end
  let(:move_regex) do
    %r{https://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}/inventory/
    move/[a-zA-Z\s%0-9]+\?auth_digest=[-a-f0-9]+&auth_time=[0-9]+}x
  end

  describe '.delete_inventory' do
    context 'deleting one inventory' do
      it 'should make the request to the object' do
        stub = stub_request(:delete, uri_regex)
        InventorySlRequest.delete_inventory(server.inventories.sample)
        expect(stub).to have_been_requested
      end
    end

    context 'error occurs' do
      it 'should raise an error' do
        stub_request(:delete, uri_regex).to_return(body: 'abc', status: 400)
        expect {
          InventorySlRequest.delete_inventory(server.inventories.sample)
        }.to raise_error(RestClient::ExceptionWithResponse)
      end
    end
  end

  describe '.batch_destroy' do
    it 'should make the request for each item' do
      stub = stub_request(:delete, uri_regex)
      ids = server.inventories.sample(3).collect(&:id)
      InventorySlRequest.batch_destroy(ids)
      expect(stub).to have_been_requested.times(3)
    end
  end

  describe '.move_inventory' do
    let(:server_two) do 
      server = FactoryBot.build :server, user_id: user.id
      server.save
      server
    end
    it 'should send the request ' do
      # body_regex = /{"server_key":"[-a-f0-9]+"}/
      body_regex = /{"target_key":"[-a-f-0-9]+","inventory_name":"[\s|\S]+"}/
      stub = stub_request(:put, move_regex).with(body: body_regex)
      InventorySlRequest.move_inventory(server.inventories.sample, server_two.id)
      expect(stub).to have_been_requested
    end

    context 'error occurs' do
      it 'should raise an error' do
        stub_request(:put, move_regex).to_return(body: 'abc', status: 400)
        expect {
          InventorySlRequest.move_inventory(server.inventories.sample, server_two.id)
        }.to raise_error(RestClient::ExceptionWithResponse)
      end
    end
  end

  describe '.give' do
    let(:avatar_key) { SecureRandom.uuid }
    it 'should make the request' do
      inventory = server.inventories.sample
      stub = stub_request(:post, give_regex)
             .with(body: "{\"inventory_name\":\"#{
              inventory.inventory_name}\",\"avatar_name\":\"#{avatar_key}\"}")
      InventorySlRequest.give_inventory(
        inventory.id, avatar_key
      )
      expect(stub).to have_been_requested
    end

    context 'error occurs' do
      it 'should raise an error' do
        stub_request(:post, give_regex).to_return(body: 'abc', status: 400)
        expect {
          InventorySlRequest.give_inventory(
            server.inventories.sample.id, SecureRandom.uuid
          )
        }.to raise_error(RestClient::ExceptionWithResponse)
      end
    end
  end
end