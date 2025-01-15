# frozen_string_literal: true

module Async
  class VisitsController < ApplicationController
    def index
      authorize :async, :index?
      # render json: send(params['chart'], params['ids'])
      render json: VisitData.send(params['chart'], params['ids'])
    end
  end
end
