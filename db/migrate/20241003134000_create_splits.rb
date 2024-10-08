class CreateSplits < ActiveRecord::Migration[7.2]
  def change
    create_table :splits do |t|
      t.integer :percent
      t.string :target_key
      t.string :target_name
      t.integer :splittable_id
      t.string :splittable_type

      t.timestamps
    end
  end
end
