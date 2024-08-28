class CreateAnalyzableInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :analyzable_inventories do |t|
      t.string :inventory_name
      t.string :inventory_key
      t.string :description
      t.integer :owner_perms
      t.integer :next_perms
      t.integer :user_id
      t.integer :server_id
      t.integer :inventory_type
      t.string :creator_name
      t.string :creator_key
      t.timestamp :date_acquired

      t.timestamps
    end
    
    add_index :analyzable_inventories, :inventory_name
    add_index :analyzable_inventories, :inventory_key
    add_index :analyzable_inventories, :description
    add_index :analyzable_inventories, :user_id
    add_index :analyzable_inventories, :creator_name
    add_index :analyzable_inventories, :inventory_type
  end
end
