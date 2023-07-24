# frozen_string_literal: true

class CreateRezzableWebObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :rezzable_web_objects do |t|
      t.string :setting_one,      default: "default"
      t.integer :setting_two,     default: 0
    end
  end
end
