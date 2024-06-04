class Api::V1::UsersController < Api::V1::ApiController
    
    def create
        @user = User.new(parsed_params)
        @user.save!
        
        render json: {
          message: I18n.t('api.user.create.success', url: Settings.site_url),
          data: @user.attributes
        }, status: :created
    end
    
    def show
        # puts params
        
        user = User.find_by_avatar_key(params["avatar_key"])
        if(user)
            data = {avatar_name: user.avatar_name, avatar_key: user.avatar_key, role: user.role, http_status: 'OK' }
            render json: data, status: :ok
        else
            data = {error_msg: 'Avatar not found.', http_status: 'NOT FOUND'}
            render json: data, status: :not_found
        end
    end
    
    private
    
  def user_params
    params.require(:user).permit(:avatar_name, :avatar_key)
  end

    
    
end


# return llSHA256String(data + api_key + (string)unix_time);

# {
#   "user-agent": "Second-Life-LSL/2024-04-13.8669470296 (https://secondlife.com)",
#   "content-length": "113",
#   "accept": "text/*, application/xhtml+xml, application/atom+xml, application/json, application/xml, application/llsd+xml, application/x-javascript, application/javascript, application/x-www-form-urlencoded, application/rss+xml",
#   "accept-charset": "utf-8;q=1.0, *;q=0.5",
#   "accept-encoding": "deflate, gzip",
#   "cache-control": "no-cache, max-age=0",
#   "content-type": "application/json",
#   "pragma": "no-cache",
#   "x-api-hash": "0f98b00f0122d3281e83b8cae48fe08dfb5e190ac923cda7e6a2670f3e739d64",
#   "x-forwarded-for": "54.213.226.73",
#   "x-forwarded-host": "slapp-data.free.beeceptor.com",
#   "x-forwarded-proto": "https",
#   "x-hash-time": "1717419950",
#   "x-secondlife-local-position": "(146.878494, 76.934807, 2000.150024)",
#   "x-secondlife-local-rotation": "(0.000000, 0.000000, 0.000000, 1.000000)",
#   "x-secondlife-local-velocity": "(0.000000, 0.000000, 0.000000)",
#   "x-secondlife-object-key": "b9cf6aa4-57be-ea8d-25d3-19adb335bb72",
#   "x-secondlife-object-name": "Base Web Object  - TEST - 0.0.1",
#   "x-secondlife-owner-key": "25c2f566-8f7d-4b82-9752-6c00216d61c8",
#   "x-secondlife-owner-name": "Rob Mimulus",
#   "x-secondlife-region": "All But Forgotten (258816, 350976)",
#   "x-secondlife-shard": "Production"
# }

# {"url":"https:\/\/simhost-062cce4bc972fc71a.agni.secondlife.io:12043\/cap\/cc6ac836-c422-e4a7-5f11-ab5c33fc28a9"}