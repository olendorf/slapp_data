# frozen_string_literal: true

class CreateAbstractWebObjects < ActiveRecord::Migration[7.1]
  def change
    create_table :abstract_web_objects do |t|
      t.string :object_name,           null: false
      t.string :object_key,            null: false
      t.string :owner_name,            null: false
      t.string :owner_key,             null: false
      t.string :region,                null: false
      t.string :position,              null: false
      t.string :shard,                 null: false, default: 'Production'
      t.string :url
      t.integer :user_id
      t.string :api_key
      t.integer :actable_id
      t.string  :actable_type

      t.timestamps
    end

    add_index :abstract_web_objects, :object_name
    add_index :abstract_web_objects, :object_key, unique: true
    add_index :abstract_web_objects, :owner_name
    add_index :abstract_web_objects, :owner_key
    add_index :abstract_web_objects, :region
    add_index :abstract_web_objects, :user_id
    add_index :abstract_web_objects, :actable_id
    add_index :abstract_web_objects, :actable_type
  end
end
