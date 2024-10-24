# frozen_string_literal: true

module ActiveAdmin
  # Common behavior for Active Admin Rezzable Controllers.
  # Primarily for interacting with in world objecs but could be other things.
  module RezzableBehavior
    extend ActiveSupport::Concern

    def self.included(base)
      base.controller do
        def update
          super
          resource.reload
          begin
            RezzableSlRequest.update_web_object!(
              resource,
              resource.response_data
            )
          rescue RestClient::ExceptionWithResponse => e
            flash[:error] = t('active_admin.web_object.update.failure',
                              message: e.response)
            # parts = request.url.split('/')[3, 2]
            # redirect_back(fallback_location: send("#{parts.first}_#{parts.last}_path"))
          end
        end

        def destroy
          logger = Rails.logger
          logger.info 'destroying'
          begin
            logger.info 'trying to destroy'
            RezzableSlRequest.derez_web_object!(resource)
          rescue RestClient::ExceptionWithResponse => e
            logger.info 'error trying to destroy'
            flash[:error] = t('active_admin.web_object.destroy.failure',
                              message: e.response)
          ensure
            logger.info 'ensuring destruction'
            puts 'Ensuring object destruction'
            super # No matter what, destory the object from the database.
          end
        end
      end
    end
  end
end
