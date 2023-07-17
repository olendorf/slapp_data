# frozen_string_literal: true

class CreateAbstractWebObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :abstract_web_objects do |t|
      t.string :object_name
      t.string :object_key
      t.string :description
      t.string :region
      t.string :position
      t.string :url
      t.string :api_key
      t.integer :user_id
      t.integer :actable_id
      t.string :actable_type
      t.datetime :pinged_at
      t.integer :major_version
      t.integer :minor_version
      t.integer :patch_version
      t.integer :server_id

      t.timestamps
    end
  end
end
