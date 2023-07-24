class AbstractWebObjectDecorator < Draper::Decorator
  delegate_all

  def slurl
    position = JSON.parse(self.position)
    href = "https://maps.secondlife.com/secondlife/#{region}/#{position['x'].round}/" \
           "#{position['y'].round}/#{position['z'].round}/"
    text = "#{region} (#{position['x'].round}, " \
           "#{position['y'].round}, #{position['z'].round})"
    h.link_to(text, href)
  end

  def semantic_version
    "#{major_version}.#{minor_version}.#{patch_version}"
  end
  
  def pretty_active
    return 'active' if active?

    'inactive'
  end

end
