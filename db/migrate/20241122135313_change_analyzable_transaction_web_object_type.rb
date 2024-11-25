class ChangeAnalyzableTransactionWebObjectType < ActiveRecord::Migration[7.2]
  def change
    
    change_column(:analyzable_transactions, :web_object_type, :string)
  end
end
