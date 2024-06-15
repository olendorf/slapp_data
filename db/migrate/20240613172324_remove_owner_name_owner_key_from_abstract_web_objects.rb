class RemoveOwnerNameOwnerKeyFromAbstractWebObjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :abstract_web_objects, :owner_name, :string
    remove_column :abstract_web_objects, :owner_key, :string
    add_column :abstract_web_objects, :description, :string
  end
end
