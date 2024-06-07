class AddExpirationDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :expiration_date, :string
    add_column :users, :web_object_count, :integer, default: 0
    add_column :users, :web_object_weight, :integer, default: 0
    add_column :users, :account_level, :integer, default: 1
  end
end
