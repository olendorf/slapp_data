# frozen_string_literal: true

module Api
  module V1
    # Controller for User API requests
    class UsersController < Api::V1::ApiController
      include ActiveRecord

      before_action :load_user, except: [:create]

      def create
        @user = User.new(parsed_params)
        @user.save!

        render json: {
          message: I18n.t('api.user.create.success', url: Settings.site_url),
          data: @user.attributes
        }, status: :created
      end

      def show
        data = {
          avatar_name: @user.avatar_name,
          avatar_key: @user.avatar_key,
          role: @user.role,
          http_status: 'OK'
        }
        render json: data, status: :ok
      end

      def update
        @user.update! parsed_params
        data = {
          avatar_name: @user.avatar_name,
          avatar_key: @user.avatar_key,
          role: @user.role,
          http_status: 'OK'
        }

        render json: {
          message: I18n.t('api.user.update.success'),
          data:
        }, status: :ok
      end

      def destroy
        @user.destroy!

        render json: {
          message: I18n.t('api.user.destroy.success'),
          http_status: 'OK'
        }, status: :ok
      end

      private

      # def user_params
      #   params.require(:user).permit(:avatar_name, :avatar_key)
      # end

      def load_user
        @user = User.find_by_avatar_key(params['avatar_key'])
        raise ActionController::RoutingError, 'User not found. Please try again.' if @user.nil?
      end
    end
  end
end
