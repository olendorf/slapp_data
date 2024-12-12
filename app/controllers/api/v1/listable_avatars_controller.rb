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
      page = page.collect { |a| [avatar_name: a.avatar_name, avatar_id: a.id] }
      data = {params['list_name'] => page.flatten }
    end
    
    render json: {message: 'OK', data: data}, status: :ok
  end
  
end
