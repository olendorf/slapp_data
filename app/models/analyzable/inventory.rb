# frozen_string_literal: true

module Analyzable
  # Models SL inventory held inside a server object.
  class Inventory < ApplicationRecord
    belongs_to :user
    belongs_to :server, class_name: 'Rezzable::Server'

    enum :inventory_type, {
      texture: 0,
      sound: 1,
      landmark: 3,
      clothing: 5,
      object: 6,
      notecard: 7,
      script: 10,
      body_part: 13,
      animation: 20,
      gesture: 21,
      setting: 56
    }

    def self.ransackable_attributes(_auth_object = nil)
      %w[
        created_at creator_key creator_name date_acquired
        description id id_value inventory_name inventory_type
        next_perms owner_perms server_id updated_at user_id
      ]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[server user]
    end

    # Some metaprogramming here to generate methods to determine
    # the perms of an inventory along the lines of owner_can_modify? or
    # next_can_transfer?
    PERMS = { copy: 0x00008000, modify: 0x0004000, transfer: 0x00002000 }.freeze

    %i[owner next].each do |who|
      PERMS.each_key do |perm|
        define_method("#{who}_can_#{perm}?") do
          (send("#{who}_perms") & PERMS[perm]).positive?
        end
      end
    end
  end
end
