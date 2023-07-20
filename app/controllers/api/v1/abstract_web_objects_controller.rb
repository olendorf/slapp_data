# frozen_string_literal: true

module Api
  module V1
    class AbstractWebObjectsController < Api::V1::ApiController
      before_action :process_atts, only: %i[create update]
      
      def create
        authorize [:api, :v1, requesting_class]
        
        @web_object = AbstractWebObject.find_by(
                  object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY']
                )
        
        # puts @web_object.inspect
        
        if @web_object
          @web_object.reset_to_defaults!
          render json: {
            message: I18n.t('api.v1.rezzable.update.success')
          }, status: :ok
        else
          @web_object = requesting_class.new(@atts)
          @web_object.save!
          
          render json: {
            data: @web_object.response_data,
            message: I18n.t('api.v1.rezzable.create.success')
          }, status: :created
        end
        
      end
      
      def index
        authorize [:api, :v1, requesting_class]
        render json: {
          data: @user.web_objects.collect do |w|
            { object_name: w.object_name, object_key: w.object_key }
          end,
          message: 'OK'
        }
      end

      def show
        authorize [:api, :v1, @requesting_object]
        # puts params
        # Rails.logger.debug(request.env.to_hash.select do |key, _val|
        #                     !key.starts_with?('rack') && !key.starts_with?('action_')
        #                   end)
        render json: {
          data: {
            settings: @requesting_object.response_data
          },
          message: 'OK'
        }
      end
      
      def update
        authorize [:api, :v1, @requesting_object]
        
        # puts params
        # puts @atts
        
        @requesting_object.update! @atts.with_indifferent_access
        
        render json: {
          data: {
            settings: @requesting_object.response_data
          },
          message: I18n.t('api.v1.rezzable.update.success')
        }
      end
      

      

      private
      

            
      def process_atts
        @atts = {
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY'],
          object_name: request.headers['HTTP_X_SECONDLIFE_OBJECT_NAME'],
          region: extract_region_name,
          position: format_position,
          user_id: User.find_by_avatar_key!(
            request.headers['HTTP_X_SECONDLIFE_OWNER_KEY']
          ).id
        }.merge(JSON.parse(request.raw_post))
      end
      
      
      def extract_region_name
        region_regex = /(?<name>[a-zA-Z0-9 ]+) ?\(?/
        matches = request.headers['HTTP_X_SECONDLIFE_REGION'].match(region_regex)
        matches[:name]
      end

      def format_position
        pos_regex = /\((?<x>[0-9.]+), (?<y>[0-9.]+), (?<z>[0-9.]+)\)/
        matches = request.headers['HTTP_X_SECONDLIFE_LOCAL_POSITION'].match(pos_regex)
        { x: matches[:x].to_f, y: matches[:y].to_f, z: matches[:z].to_f }.to_json
      end

      def requesting_class
        "::Rezzable::#{controller_name.classify}".constantize
      end
    end
  end
end
