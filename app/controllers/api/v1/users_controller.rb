# frozen_string_literal: true

module Api
  module V1
    # Controller for User API requests
    class UsersController < Api::V1::ApiController
      include ActiveRecord

      before_action :load_user, except: [:create]

      def create
        authorize [:api, :v1, User]
        load_requesting_object
        @user = User.new(parsed_params.merge(requesting_object: @requesting_object))
        @user.save!
        
        response_data = @user.attributes
        response_data[:expiration_date] = response_data["expiration_date"].strftime('%b %d, %Y %I:%M %p')

        render json: {
          message: I18n.t('api.user.create.success', url: Settings.default.site_url),
          data: response_data
        }, status: :created
      end

      def show
        authorize [:api, :v1, User]
        if @user
          data = {
            avatar_name: @user.avatar_name,
            avatar_key: @user.avatar_key,
            role: @user.role,
            expiration_date: @user.expiration_date,
            account_level: @user.account_level,
            object_weight: @user.web_object_weight,
            object_count: @user.web_object_count,
            http_status: 'OK',
            payment_schedule: User.payment_schedule
          }
        else
          data = {
            http_status: 'OK',
            payment_schedule: User.payment_schedule
          }
        end
        render json: data, status: :ok
      end

      def update
        authorize [:api, :v1, User]
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
        authorize [:api, :v1, User]
        @user.destroy!

        render json: {
          message: I18n.t('api.user.destroy.success'),
          http_status: 'OK'
        }, status: :ok
      end
      
      # def payment_schedule
      #   payment_schedule = {}
      #   monthly_cost = Settings.default.account.monthly_cost
      #   Settings.default.account.discount_schedule.each do |k, v|
      #     payment_schedule[((monthly_cost - (monthly_cost * v).round) * (k.to_s.to_i))] = k
      #   end
      #   payment_schedule
      # end

      private

      # def user_params
      #   params.require(:user).permit(:avatar_name, :avatar_key)
      # end

      def load_user
        @user = User.find_by_avatar_key(params['avatar_key'])
        # raise ActionController::RoutingError, 
        #         'User not found. Please try again.' if @user.nil?
      end
    end
  end
end
