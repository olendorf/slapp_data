# frozen_string_literal: true

module Api
  module V1
    # Controller for all API web object requests. Almost everythign is handled here.
    class RezzableController < Api::V1::ApiController
      before_action :load_requested_object, except: [:create]

      def create
        @web_object = requesting_class.new(object_attributes)
        # @web_object.save!
        @object_owner.web_objects << @web_object

        render json: {
          data: {
            api_key: @web_object.api_key,
            message: I18n.t('api.web_object.create.success'),
            http_status: 'CREATED'
          }
        }, status: :created
      end

      def show
        render json: {
          data: @web_object.attributes.with_indifferent_access.except(
            'id', 'url', 'user_id', 'created_at', 'updated_at'
          ),
          http_status: 'OK'
        }, status: :ok
      end

      def update
        params.permit!
        @web_object.update! params[controller_name.singularize]

        render json: {
          data: {
            message: I18n.t('api.web_object.update.success'),
            http_status: 'OK'
          }
        }, status: :ok
      end

      def destroy
        @web_object.destroy!
        render json: {
          data: {
            message: I18n.t('api.web_object.destroy.success'),
            http_status: 'OK'
          }
        }, status: :ok
      end

      private

      def load_requested_object
        @web_object = AbstractWebObject.find_by_object_key(
          params['object_key']
        )

        if @web_object.nil?
          raise ActionController::RoutingError,
                'User not found. Please try again.'
        end

        @web_object.actable
      end

      def requesting_class
        "::Rezzable::#{controller_name.classify}".constantize
      end

      def object_attributes
        {
          object_name: request.headers['HTTP_X_SECONDLIFE_OBJECT_NAME'],
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY'],
          # owner_name: request.headers['HTTP_X_SECONDLIFE_OWNER_NAME'],
          # owner_key: request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'],
          region: extract_region_name,
          position: extract_position,
          shard: request.headers['HTTP_X_SECONDLIFE_SHARD'],
          url: params[:url]

        }
      end

      def extract_region_name
        region_regex = /(?<name>[a-zA-Z0-9 ]+) ?\(?/
        matches = request.headers['HTTP_X_SECONDLIFE_REGION'].match(region_regex)
        matches[:name]
      end

      def extract_position
        pos = JSON.parse(request.headers['HTTP_X_SECONDLIFE_LOCAL_POSITION'])
        { x: pos[0], y: pos[1], z: pos[2] }.to_json
      end
    end
  end
end

#   "x-auth-time": "1717606924",
#   "x-forwarded-for": "54.200.222.248",
#   "x-forwarded-host": "slapp-data.free.beeceptor.com",
#   "x-forwarded-proto": "https",
#   "x-secondlife-local-position": "(146.878494, 76.934807, 2000.150024)",
#   "x-secondlife-local-rotation": "(0.000000, 0.000000, 0.000000, 1.000000)",
#   "x-secondlife-local-velocity": "(0.000000, 0.000000, 0.000000)",
#   "x-secondlife-object-key": "b9cf6aa4-57be-ea8d-25d3-19adb335bb72",
#   "x-secondlife-object-name": "Base Web Object  - TEST - 0.0.1",
#   "x-secondlife-owner-key": "25c2f566-8f7d-4b82-9752-6c00216d61c8",
#   "x-secondlife-owner-name": "Rob Mimulus",
#   "x-secondlife-region": "All But Forgotten (258816, 350976)",
#   "x-secondlife-shard": "Production"
