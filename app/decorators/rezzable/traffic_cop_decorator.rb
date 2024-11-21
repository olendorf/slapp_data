# frozen_string_literal: true

module Rezzable
  # Decorator for Web Objects. Most methods will be in AbstractWebObjectDecorator.
  class TrafficCopDecorator < AbstractWebObjectDecorator
    delegate_all

    def pretty_power
      h.content_tag :span, class: power_off? ? 'status_tag off' : 'status_tag on' do
        power_off? ? 'Off' : 'On'
      end
    end

    def pretty_sensor_mode
      sensor_mode.split('_')[2..].join(' ').titleize
    end

    def pretty_security_mode
      security_mode.split('_')[2..].join(' ').titleize
    end

    def pretty_access_mode
      access_mode.split('_')[2..].join(' ').titleize
    end

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
  end
end
