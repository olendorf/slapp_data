# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Pundit::Authorization
      include Api::ExceptionHandler
      include Api::ResponseHandler

      before_action :load_requesting_object, except: [:create]
      before_action :load_user
      before_action :validate_package

      after_action :verify_authorized
      
      def api_key
        return Settings.default.web_object.api_key if action_name.downcase == 'create'

        @requesting_object.api_key
      end

      def parsed_params
        JSON.parse(request.raw_post)
      end

      def load_requesting_object
        @requesting_object = AbstractWebObject.find_by(
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY']
        ).actable
      end
      
      def pundit_user
        User.find_by_avatar_key!(request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'])
      end

      def load_user
        @user = User.find_by(
          avatar_key: request.headers['HTTP_X_SECONDLIFE_OWNER_KEY']
        )
      end
      
      def validate_package(time_limit = 30)
        unless (Time.now.to_i - auth_time).abs < time_limit
          raise(
            ActionController::BadRequest, I18n.t('api.v1.errors.auth_time')
          )
        end

        # rubocop:disable Style/GuardClause
        unless auth_digest == create_digest
          raise(
            ActionController::BadRequest, I18n.t('api.v1.errors.auth_digest')
          )
        end
        # rubocop:enable Style/GuardClause
      end

      def auth_digest
        request.headers['HTTP_X_AUTH_DIGEST']
      end

      def auth_time
        return 0 unless request.headers['HTTP_X_AUTH_TIME']

        request.headers['HTTP_X_AUTH_TIME'].to_i
      end

      def create_digest
        Digest::SHA1.hexdigest(auth_time.to_s + api_key)
      end
    end
  end
end
