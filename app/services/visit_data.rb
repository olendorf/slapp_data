# frozen_string_literal: true

# Handles data processing for parcels
class VisitData
  # include DataHelper

  def self.visits_histogram(ids)
    Analyzable::Visit.select(:duration).where(traffic_cop_id: ids).collect do |v|
      v.duration / 60.0
    end.compact
  end
end