class CreateAnalyzableTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :analyzable_transactions do |t|
      t.integer :amount
      t.integer :balance
      t.integer :previous_balance
      t.integer :user_id
      t.string :target_key
      t.string :target_name
      t.string :description
      t.integer :transaction_type, default: 0
      t.integer :abstract_web_object_id
      t.integer :web_object_type
      

      t.timestamps
    end
  end
end
