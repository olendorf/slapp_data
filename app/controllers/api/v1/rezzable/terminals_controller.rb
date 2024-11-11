# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      class TerminalsController < Api::V1::RezzableController
        def give
          authorize [:api, :v1, @requesting_object.actable]
          
          begin
            target_user = User.find_by_avatar_key(params['avatar_key'])
            InventorySlRequest.give_inventory(@requesting_object.inventory_id, target_user.avatar_name)
          rescue Exception => e
          end
          
          render json: {
            data: @requesting_object.attributes.with_indifferent_access.except(
              'id', 'url', 'user_id', 'created_at', 'updated_at'
            ),
            http_status: 'OK'
          }, status: :ok
        end
      end
    end
  end
end
