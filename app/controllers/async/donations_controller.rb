# frozen_string_literal: true

module Async
  # Controller for Asynchronous requests from Donation Box pages
  class DonationsController < ApplicationController
    def index
      authorize :async, :index?
      render json: DonationData.send(params['chart'], params['ids'])
    end
  end
end
