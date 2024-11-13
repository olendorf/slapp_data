class CreateAnalyzableDetections < ActiveRecord::Migration[7.2]
  def change
    create_table :analyzable_detections do |t|
      t.float :x
      t.float :y
      t.float :z
      t.integer :visit_id

      t.timestamps
    end
  end
end
