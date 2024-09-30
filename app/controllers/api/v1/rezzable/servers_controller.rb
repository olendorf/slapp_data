# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      class ServersController < Api::V1::RezzableController
        
        def index
          authorize [:api, :v1, @requesting_object.actable]

          params['server_page'] ||= 1
          page = @requesting_object.user.servers
                                   .page(params['server_page']).per(9)
          data = paged_data(page)
          render json: { data: }, status: :ok
        end
        
        
        private 
        def paged_data(page)
          {
            server_names: page.map(&:object_name),
            server_keys: page.map(&:object_key),
            current_page: page.current_page,
            next_page: page.next_page,
            prev_page: page.prev_page,
            total_pages: page.total_pages
          }
        end
      end
    end
  end
end
