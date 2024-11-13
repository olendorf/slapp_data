class CreateRezzableTrafficCops < ActiveRecord::Migration[7.2]
  def change
    create_table :rezzable_traffic_cops do |t|
      t.timestamps
    end
  end
end
