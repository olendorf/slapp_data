# frozen_string_literal: true

module Async
  # Controller for Asynchronous requests from Visits web pages.
  class VisitsController < ApplicationController
    def index
      authorize :async, :index?
      # render json: send(params['chart'], params['ids'])
      render json: VisitData.send(params['chart'], params['ids'])
    end
  end
end
