# frozen_string_literal: true

module Async
  class DonationsController < ApplicationController
    def index
      authorize :async, :index?
      render json: DonationData.send(params['chart'], params['ids'])
    end
  end
end
