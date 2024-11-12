class AddInventoryIdToAbstractWebObject < ActiveRecord::Migration[7.2]
  def change
    add_column :abstract_web_objects, :inventory_id, :integer
  end
end
