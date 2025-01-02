class Async::VisitsController < ApplicationController
  def index
    authorize :async, :index?
    render json: send(params['chart'], params['ids'])
  end
  
  def visits_histogram(ids)
    VisitData.visits_histogram(ids)
  end
end
