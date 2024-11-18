class AddColumnsToRezzableTrafficCop < ActiveRecord::Migration[7.2]
  def change
    add_column :rezzable_traffic_cops, :sensor_mode, :integer
    add_column :rezzable_traffic_cops, :security_mode, :integer
    add_column :rezzable_traffic_cops, :access_mode, :integer
    add_column :rezzable_traffic_cops, :first_visit_message, :string, default: "Welcome!"
    add_column :rezzable_traffic_cops, :repeat_visit_message, :string, default: "Welcome back!"
    add_column :rezzable_traffic_cops, :banned_message, :string, default: "You are not allowed access."
  end
end
