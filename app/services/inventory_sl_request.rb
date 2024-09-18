# frozen_string_literal: true

# Handles requests into SL to manage server inventory.
class InventorySlRequest
  include SlRequestConcern

  def self.delete_inventory(inventory)
    server = inventory.server

    RestClient::Request.execute(
      url: "#{server.url}/inventory/inventories/#{
                ERB::Util.url_encode(inventory.inventory_name)}",
      method: :delete,
      content_type: :json,
      accept: :json,
      verify_ssl: false,
      headers: request_headers(server)
    ) unless Rails.env.development?
  end

  def self.batch_destroy(*ids)
    ids.first.each do |id|
      delete_inventory(Analyzable::Inventory.find(id))
    end
  end

  def self.move_inventory(inventory, server_id)
    server = inventory.server
    target_server = Rezzable::Server.find(server_id)

    RestClient::Request.execute(
      url: "#{server.url}/inventory/move/#{
                ERB::Util.url_encode(inventory.inventory_name)}",
      method: :put,
      content_type: :json,
      accept: :json,
      payload: { 
        server_key: target_server.object_key, 
        inventory_name: inventory.inventory_name 
      }.to_json,
      verify_ssl: false,
      headers: request_headers(server)
    ) unless Rails.env.development?
  end

  def self.give_inventory(inventory_id, avatar_name)
    inventory = Analyzable::Inventory.find(inventory_id)
    server = inventory.server

    RestClient::Request.execute(
      url: "#{server.url}/inventory/give",
      method: :post,
      content_type: :json,
      accept: :json,
      payload: { inventory_name: inventory.inventory_name,
                 avatar_name: avatar_name }.to_json,
      verify_ssl: false,
      headers: request_headers(server)
    ) unless Rails.env.development?
  end
end