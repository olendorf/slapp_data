# frozen_string_literal: true

class AddExpirationDateToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :expiration_date, :datetime
  end
end
