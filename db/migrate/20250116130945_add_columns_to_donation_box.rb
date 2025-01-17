class AddColumnsToDonationBox < ActiveRecord::Migration[7.2]
  def change
    add_column :rezzable_donation_boxes, :show_last_tipper, :boolean, default: true
    add_column :rezzable_donation_boxes, :show_last_amount, :boolean, default: true
    add_column :rezzable_donation_boxes, :show_biggest_tipper, :boolean, default: true
    add_column :rezzable_donation_boxes, :show_total, :boolean, default: true
  end
end
