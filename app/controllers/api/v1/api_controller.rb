# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Pundit::Authorization

      before_action :load_requesting_object, except: [:create]
      before_action :load_user

      after_action :verify_authorized

      def load_requesting_object
        @requesting_object = AbstractWebObject.find_by(
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY']
        ).actable
      end

      def load_user
        @user = User.find_by(
          avatar_key: request.headers['HTTP_X_SECONDLIFE_OWNER_KEY']
        )
      end
    end
  end
end
