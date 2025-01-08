# frozen_string_literal: true

module Analyzable
  # Decorator class for Analyzable::Visit model
  class VisitDecorator < Draper::Decorator
    delegate_all
    
    def slurl
      href = "https://maps.secondlife.com/secondlife/#{region}/#{detections.last.x.round}/" \
             "#{detections.last.y.round}/#{detections.last.z.round}/"
      text = "#{avatar_name} (#{detections.last.x.round}, " \
            "#{detections.last.y.round}, #{detections.last.z.round})"
      h.link_to(text, href, target: :_blank)
      # href
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
