class RemoveUpdatedAtCreatedAtFromActables < ActiveRecord::Migration[7.2]
  def change
    remove_column :rezzable_traffic_cops, :created_at
    remove_column :rezzable_traffic_cops, :updated_at
    remove_column :rezzable_terminals, :created_at
    remove_column :rezzable_terminals, :updated_at
    remove_column :rezzable_servers, :created_at
    remove_column :rezzable_servers, :updated_at
    remove_column :rezzable_donation_boxes, :created_at
    remove_column :rezzable_donation_boxes, :updated_at
  end
end
