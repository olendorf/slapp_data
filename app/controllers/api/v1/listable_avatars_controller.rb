class Api::V1::ListableAvatarsController < Api::V1::ApiController
  
  def create
    authorize [:api, :v1, @requesting_object.actable]
  end
  
  def index
    authorize [:api, :v1, @requesting_object.actable]
    data = ""
    logger.debug "raw params: #{params}"
    if params['listable_avatar_page'] == 'all'
      page = @requesting_object.actable.send(params['list_name'].to_sym)
      logger.debug "raw page data: #{page}"
      page = page.collect { |a| a.avatar_name }
      logger.debug "processed data: #{page}"
      data = {params['list_name'] => page}
    else
      params['listable_avatar_page'] ||= 1
      page = @requesting_object.actable.send(params['list_name'].to_sym)
                    .page(params['listable_avatar_page']).per(9)
      data = paged_data(page)
    end
    
    render json: {message: 'OK', data: data}, status: :ok
  end
  
  private
  
  def paged_data(page)
    {
      avatar_names: page.map(&:avatar_name),
      avatar_ids: page.map(&:id),
      current_page: page.current_page,
      next_page: page.next_page,
      prev_page: page.prev_page,
      total_pages: page.total_pages
    }
  end
  
end
