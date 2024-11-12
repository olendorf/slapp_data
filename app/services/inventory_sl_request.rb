# frozen_string_literal: true

# Handles requests into SL to manage server inventory.
class InventorySlRequest
  include SlRequestConcern

  def self.delete_inventory(inventory)
    server = inventory.server

    return if Rails.env.development?

    RestClient::Request.execute(
      url: "#{server.url}/inventory/inventories/#{
                  ERB::Util.url_encode(inventory.inventory_name)}",
      method: :delete,
      content_type: :json,
      accept: :json,
      verify_ssl: false,
      headers: request_headers(server)
    )
  end

  def self.batch_destroy(*ids)
    ids.first.each do |id|
      delete_inventory(Analyzable::Inventory.find(id))
    end
  end

  def self.move_inventory(inventory, server_id)
    server = inventory.server
    target_server = Rezzable::Server.find(server_id)

    return if Rails.env.development?

    RestClient::Request.execute(
      url: "#{server.url}/inventory/move/#{
                  ERB::Util.url_encode(inventory.inventory_name)}",
      method: :put,
      content_type: :json,
      accept: :json,
      payload: {
        target_key: target_server.object_key,
        inventory_name: inventory.inventory_name
      }.to_json,
      verify_ssl: false,
      headers: request_headers(server)
    )
  end

  def self.give_inventory(inventory_id, avatar_name)
    inventory = Analyzable::Inventory.find(inventory_id)
    target_server = inventory.server

    # Rails.logger.debug "Giving inventory #{inventory.inventory_name}"

    return if Rails.env.development?

    RestClient::Request.execute(
      url: "#{target_server.url}/inventory/give",
      method: :post,
      content_type: :json,
      accept: :json,
      payload: { inventory_name: inventory.inventory_name,
                 avatar_name: }.to_json,
      verify_ssl: false,
      headers: request_headers(target_server)
    )
  end
end
