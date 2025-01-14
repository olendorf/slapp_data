# frozen_string_literal: true

# Base decorator for all rezzable decorators. They should inherit form this.
class AbstractWebObjectDecorator < Draper::Decorator
  delegate_all

  def slurl(target: :_blank)
    position = JSON.parse(self.position)
    href = "http://maps.secondlife.com/secondlife/#{region.strip}/#{position['x'].to_i.round}/" \
           "#{position['y'].to_i.round}/#{position['z'].to_i.round}/"
    text = "#{region.strip} (#{position['x'].to_i.round}, " \
           "#{position['y'].to_i.round}, #{position['z'].to_i.round})"
    h.link_to(text, href, target: target)
  end
  
  def pretty_status
    h.content_tag :span, class: active? ? 'status_tag off' : 'status_tag on' do
      active? ? 'Inactive' : 'Active'
    end
  end
  
  # http://maps.secondlife.com/secondlife/Schear/228/36/2505

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
