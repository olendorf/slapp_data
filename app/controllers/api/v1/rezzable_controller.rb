# frozen_string_literal: true

module Api
  module V1
    # Controller for all API web object requests. Almost everythign is handled here.
    class RezzableController < Api::V1::ApiController
      # before_action :load_requested_object, except: [:create]

      def create
        if AbstractWebObject.find_by_object_key(object_attributes[:object_key])
          load_requesting_object
          update
        else
          authorize [:api, :v1, requesting_class]
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
      end

      def show
        authorize [:api, :v1, @requesting_object.actable]
        render json: {
          data: @requesting_object.attributes.with_indifferent_access.except(
            'id', 'url', 'user_id', 'created_at', 'updated_at'
          ),
          http_status: 'OK'
        }, status: :ok
      end

      def update
        authorize [:api, :v1, @requesting_object.actable]
        params.permit!
        @requesting_object.update! object_attributes

        render json: {
          data: {
            api_key: @requesting_object.api_key,
            message: I18n.t('api.web_object.update.success'),
            http_status: 'OK'
          }
        }, status: :ok
      end

      def destroy
        authorize [:api, :v1, @requesting_object.actable]
        @requesting_object.destroy!
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

      def object_params; end

      def object_attributes
        params[controller_name.singularize]
        {
          object_name: request.headers['HTTP_X_SECONDLIFE_OBJECT_NAME'],
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY'],
          # owner_name: request.headers['HTTP_X_SECONDLIFE_OWNER_NAME'],
          # owner_key: request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'],
          region: extract_region_name,
          position: extract_position,
          shard: request.headers['HTTP_X_SECONDLIFE_SHARD']
        }.merge(params[controller_name.singularize].to_unsafe_hash).with_indifferent_access
      end

      def extract_region_name
        region_regex = /(?<name>[a-zA-Z0-9 ]+) ?\(?/
        matches = request.headers['HTTP_X_SECONDLIFE_REGION'].match(region_regex)
        matches[:name]
      end

      def extract_position
        position_regex = /\((?<x>[0-9]+.[0-9]+), *(?<y>[0-9]+.[0-9]+), *(?<z>[0-9]+.[0-9]+)\)/

        pos = request.headers['HTTP_X_SECONDLIFE_LOCAL_POSITION'].match(position_regex)
        { x: pos[:x], y: pos[:y], z: pos[:z] }.to_json
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
