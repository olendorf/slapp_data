# frozen_string_literal: true

# Handles data processing for parcels
class VisitData
  # include DataHelper

  def self.visits_histogram(ids)
    Analyzable::Visit.select(:duration).where(traffic_cop_id: ids).collect do |v|
      v.duration / 60.0
    end.compact
  end
  
  
  def self.visitors_time_histogram(ids)
    Analyzable::Visit.where(traffic_cop_id: ids)
                     .group(:avatar_key).sum(:duration).collect do |_k, v|
      v / 60.0
    end
  end
end