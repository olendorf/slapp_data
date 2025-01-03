class Async::VisitsController < ApplicationController
  def index
    authorize :async, :index?
    render json: send(params['chart'], params['ids'])
  end
  
  def visits_histogram(ids)
    VisitData.visits_histogram(ids)
  end
  
  def visitors_time_histogram(ids)
    VisitData.visitors_time_histogram(ids)
  end
  
  def visitors_counts_histogram(ids)
      Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_key).count.collect { |_k, v| v }
  end
  
  def visitors_duration_counts_scatter(ids)
    counts = Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_name).count
    durations = Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_name).sum(:duration)
    counts.collect { |k, v| { x: v, y: durations[k] / 60.0, name: k } }
  end
end
