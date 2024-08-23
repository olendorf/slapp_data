class AddObjectCountAndObjectWeightToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :object_weight, :integer, default: 0
    add_column :users, :object_count, :integer, default: 0
    add_column :abstract_web_objects, :server_id, :integer
  end
end
