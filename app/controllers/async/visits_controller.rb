class Async::VisitsController < ApplicationController
  def index
    authorize :async, :index?
    # render json: send(params['chart'], params['ids'])
    render json: VisitData.send(params['chart'], params['ids'])
  end
end
