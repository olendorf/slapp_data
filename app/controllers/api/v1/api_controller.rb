# frozen_string_literal: true

module Api
  module V1
    # Base controller for all api requests.
    class ApiController < ApplicationController
      include Api::ExceptionHandler
      include Api::ResponseHandler

      skip_before_action :verify_authenticity_token

      before_action :load_requesting_object, except: [:create]
      before_action :validate_request

  

      private

      def load_requesting_object
        @requesting_object = AbstractWebObject.find_by_object_key(
          request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY']
        )

        if @requesting_object.nil?
          raise ActionController::RoutingError,
                'User not found. Please try again.'
        end

        @requesting_object.actable
      end

      def hash_time
        request.headers['HTTP_X_AUTH_TIME']
      end

      def auth_digest
        request.headers['HTTP_X_AUTH_DIGEST']
      end

      def validate_request
        unless (Time.now.to_i - hash_time).abs < Settings.default.request.time_limit
          raise(
            ActionController::BadRequest, I18n.t('errors.auth_time')
          )
        end
        return if auth_digest == validation_digest

        raise(
          ActionController::BadRequest, I18n.t('errors.auth_digest')
        )
      end

      def validation_digest
        Digest::SHA256.hexdigest(api_key + hash_time.to_s)
      end

      def api_key
        return @requesting_object[:api_key] if @requesting_object && @requesting_object[:api_key]

        Settings.default.web_object.api_key
      end

      def parsed_params
        JSON.parse(request.raw_post)
      end
    end
  end
end
