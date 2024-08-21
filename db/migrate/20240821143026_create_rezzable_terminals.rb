class CreateRezzableTerminals < ActiveRecord::Migration[7.2]
  def change
    create_table :rezzable_terminals do |t|
      t.timestamps
    end
  end
end
