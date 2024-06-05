# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string  :avatar_name,              null: false, default: ''
      t.string  :avatar_key,               null: false, default: '00000000-0000-0000-0000-000000000000'
      t.integer :role,                     null: false, default: 0
      t.string  :encrypted_password,       null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :avatar_name,                unique: true
    add_index :users, :avatar_key,                 unique: true
  end
end
