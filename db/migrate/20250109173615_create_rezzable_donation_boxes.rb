class CreateRezzableDonationBoxes < ActiveRecord::Migration[7.2]
  def change
    create_table :rezzable_donation_boxes do |t|
      t.string :payment_schedule
      t.string :message

      t.timestamps
    end
  end
end
