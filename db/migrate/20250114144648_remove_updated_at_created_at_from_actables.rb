class RemoveUpdatedAtCreatedAtFromActables < ActiveRecord::Migration[7.2]
  def change
    remove_column :rezzable_traffic_cops, :created_at, :datetime
    remove_column :rezzable_traffic_cops, :updated_at, :datetime
    remove_column :rezzable_terminals, :created_at, :datetime
    remove_column :rezzable_terminals, :updated_at, :datetime
    remove_column :rezzable_servers, :created_at, :datetime
    remove_column :rezzable_servers, :updated_at, :datetime
    remove_column :rezzable_donation_boxes, :created_at, :datetime
    remove_column :rezzable_donation_boxes, :updated_at, :datetime
    add_column :abstract_web_objects, :pinged_at, :datetime
  end
end
