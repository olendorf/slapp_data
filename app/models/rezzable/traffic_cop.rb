# frozen_string_literal: true

module Rezzable
  # Model for Traffic cops that collect visit data and manager security
  class TrafficCop < ApplicationRecord
    acts_as :abstract_web_object

    has_many :visits, class_name: 'Analyzable::Visit', dependent: :nullify

    has_many :listable_avatars, as: :listable, dependent: :destroy
    
    accepts_nested_attributes_for :listable_avatars, allow_destroy: true

    attr_accessor :detections, :outgoing_messages

    before_update :handle_detections, if: :detections

    enum :sensor_mode, {
      sensor_mode_region: 0,
      sensor_mode_parcel: 1,
      sensor_mode_owned: 2
    }

    enum :security_mode, {
      security_mode_off: 0,
      security_mode_parcel: 1,
      security_mode_owned_parcels: 2
    }

    enum :access_mode, {
      access_mode_anyone: 0,
      access_mode_banned: 1,
      access_mode_allowed: 2
    }

    enum :power, {
      power_off: 0,
      power_on: 1
    }

    OBJECT_WEIGHT = 25

    LISTS = %i[allowed banned excluded].freeze

    LISTS.each do |list|
      define_method("add_to_#{list}") do |avatar_name, avatar_key|
        listable_avatars << ListableAvatar.new(
          avatar_name:,
          avatar_key:,
          list_name: list.to_s
        )
      end

      define_method("#{list}") do
        listable_avatars.where(list_name: list.to_sym)
      end
    end


    def self.ransackable_associations(_auth_object = nil)
      %w[abstract_web_object actable user created_at]
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id id_value]
    end

    def current_visitors
      visits.where('updated_at > ?', 2.minutes.ago)
    end

    def response_data
      data = {
        description:,
        object_key:,
        object_name:,
        api_key:,
        first_visit_message:,
        repeat_visit_message:,
        banned_message:,
        outgoing_messages:,
        access_mode:,
        sensor_mode:,
        power:,
        server_name: nil,
        server_id: nil,
        inventory_name: nil,
        inventory_id: nil
      }
      if(self.inventory)
        data[:inventory_name] = self.inventory.inventory_name
        data[:inventory_id] = self.inventory.id
      end
      if(self.server)
        data[:server_name] = self.server.object_name
        data[:server_id] = self.server.id
      end
      data
    end

    def visitors
      counts = visits.group(:avatar_key).count
      data = visits.group(:avatar_key, :avatar_name).sum(:duration).collect do |k, v|
        { avatar_name: k.last, avatar_key: k.first, time_spent: v, visits: counts[k.first] }
      end
      data.sort_by { |h| -h[:time_spent] }
    end

    private

    def handle_detections
      self.outgoing_messages = { first_visit: [], repeat_visit: [], eject: [] }

      detections.each do |detection|
        handle_detection(detection)
      end
      outgoing_messages[:first_visit] =
        outgoing_messages[:first_visit] - outgoing_messages[:eject]
      outgoing_messages[:first_visit] =
        outgoing_messages[:first_visit] - outgoing_messages[:repeat_visit]
      self.detections = nil
    end

    # rubocop:disable Metrics/AbcSize
    def handle_detection(detection)
      detection = detection.with_indifferent_access
      
      return unless self.excluded.where(avatar_key: detection[:avatar_key]).empty?
      
      previous_visit = visits.where(avatar_key: detection['avatar_key'])
                             .order(created_at: :desc).limit(1).first

      outgoing_messages[:eject] << detection[:avatar_key] unless access?(detection)

      if previous_visit.nil? || !previous_visit.active?
        if previous_visit.nil?
          outgoing_messages[:first_visit] << detection[:avatar_key]
          InventorySlRequest.give_inventory(inventory_id, detection['avatar_name']) if inventory_id
        end
        if previous_visit && previous_visit.created_at < 1.week.ago
          outgoing_message[:repeat_visit] << detection[:avatar_key]
        end
        create_visit(detection)
      else
        if visits.last.created_at < 1.week.ago
          outgoing_messages[:repeat_visit] << detection[:avatar_key]
        end
        previous_visit.detections << Analyzable::Detection.create(detection)
      end
    end

    # rubocop:enable Metrics/AbcSize

    def create_visit(detection)
      atts = {
        avatar_name: detection['avatar_name'],
        avatar_key: detection['avatar_key'],
        region:,
        user_id:
      }

      visit = Analyzable::Visit.create(atts)
      visit.detections << Analyzable::Detection.new(detection)
      visits << visit
    end

    def access?(detection)
      has_access = banned.where(avatar_key: detection[:avatar_key]).empty?
      if access_mode_allowed? && has_access
        has_access = allowed.where(avatar_key: detection[:avatar_key]).size.positive?
      end
      has_access
    end
  end
end
