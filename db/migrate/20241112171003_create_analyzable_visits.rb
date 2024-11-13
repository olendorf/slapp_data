class CreateAnalyzableVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :analyzable_visits do |t|
      t.string :avatar_name
      t.string :avatar_key
      t.string :region
      t.integer :duration
      t.integer :traffic_cop_id
      t.integer :user_id

      t.timestamps
    end
  end
end
