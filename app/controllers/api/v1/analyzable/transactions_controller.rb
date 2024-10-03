# frozen_string_literal: true

module Api
  module V1
    module Analyzable
      # Handles transaction requests from in world objects
      class TransactionsController < Api::V1::AnalyzableController
        def create
          authorize [:api, :v1, @requesting_object.actable]
          atts = params['transaction'].merge(
            {
              abstract_web_object_id: @requesting_object.id
            }
          )
          atts.permit!
          transaction = Analyzable::Transaction.new(atts)
          @object_owner.transactions << transaction
          render json: { message: 'CREATED' }, status: :created
        end
      end
    end
  end
end
