class AddExpirationDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :expiration_date, :datetime
    add_column :users, :web_object_count, :integer, default: 0
    add_column :users, :web_object_weight, :integer, default: 0
    add_column :users, :account_level, :integer, default: 1
    add_index :users, :expiration_date
    add_index :users, :web_object_count
    add_index :users, :web_object_weight
    add_index :users, :account_level
  end
end
