class AddColumnsToRezzableTrafficCop < ActiveRecord::Migration[7.2]
  def change
    add_column :rezzable_traffic_cops, :sensor_mode, :integer
    add_column :rezzable_traffic_cops, :security_mode, :integer
    add_column :rezzable_traffic_cops, :access_mode, :integer
  end
end
