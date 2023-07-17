# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      class WebObjectsController <
                                        Api::V1::AbstractWebObjectsController
        def index
          authorize [:api, :v1, requesting_class]
          render json: {
            data: @user.web_objects.collect do |w|
              { object_name: w.object_name, object_key: w.object_key }
            end,
            message: 'Success!'
          }
        end

        def show
          authorize [:api, :v1, @requesting_object]
          # puts params
          Rails.logger.debug(request.env.to_hash.select do |key, _val|
                               !key.starts_with?('rack') && !key.starts_with?('action_')
                             end)
          render json: {
            data: {
              settings: @requesting_object.settings
            },
            message: 'Success!'
          }
        end

        private

        def requesting_class
          "::Rezzable::#{controller_name.classify}".constantize
        end
      end
    end
  end
end
