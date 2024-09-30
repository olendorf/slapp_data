class Analyzable::InventoryDecorator < AnalyzableDecorator
  delegate_all
  
  def pretty_perms(who)
    output = []
    Analyzable::Inventory::PERMS.each do |perm, flag|
      output << perm.to_s.titlecase if (flag & send("#{who}_perms")).positive?
    end
    output.join('|')
  end

  # def image_url(size)
  #   return 'no_image_available.jpg' unless product

  #   product.decorate.image_url(size)
  # end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
