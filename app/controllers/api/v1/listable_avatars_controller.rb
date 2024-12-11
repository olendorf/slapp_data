class Api::V1::ListableAvatarsController < Api::V1::ApiController
  
  def create
    authorize [:api, :v1, @requesting_object.actable]
  end
  
  def index
    authorize [:api, :v1, @requesting_object.actable]
    data = ""
    if params['listable_avatar_page'] == 'all'
      page = @requesting_object.actable.send(params['list_name'].to_sym)
      page = page.collect { |a| a.avatar_name }
      data = {params['list_name'] => page}
    else
      params['listable_avatar_page'] ||= 1
      page = @requesting_object.actable.send(params['list_name'].to_sym)
                    .page(params['listable_avatar_page']).per(9)
      page = page.collect { |a| {avatar_key: a.avatar_key, avatar_name: a.avatar_name} }
      data = {params['list_name'] => page }
    end
    
    render json: {message: 'OK', data: data}, status: :ok
  end
  
end
