# frozen_string_literal: true

# Handles data processing for parcels
class VisitData
  # include DataHelper
  
  def self.visits_timeline(ids)
    visits = Rezzable::TrafficCop.find(ids).first.visits
    data = visits.group_by_day(:created_at).count
    counts = data.collect{ |k, v| v}
    durations = visits.group_by_day(:created_at).sum(:duration).collect{ |k, v| v }.map { |v| v/60.0}
    dates = data.keys.map { |k| k }
    [dates, counts, durations]
    
  end
  
  def self.duration_timeline(ids)
  end

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
  
  def self.visitors_counts_histogram(ids)
      Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_key).count.collect { |_k, v| v }
  end
  
  def self.visitors_duration_counts_scatter(ids)
    counts = Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_name).count
    durations = Analyzable::Visit.where(traffic_cop_id: ids).group(:avatar_name).sum(:duration)
    counts.collect { |k, v| { x: v, y: durations[k] / 60.0, name: k } }
  end
  
  def self.visits_heatmap(ids)
    visits = Analyzable::Visit.where(traffic_cop_id: ids).order(:created_at)
    data = []
    (0..6).each { |d| (0..23).each { |h| data << [d, h, 0] } }
    visits.each do |visit|
      h = visit.created_at.strftime('%k').to_i
      d = visit.created_at.strftime('%w').to_i
      data[(d * 24) + h][2] = data[(d * 24) + h][2] + 1
    end
    data
  end

  def self.duration_heatmap(ids)
    visits = Analyzable::Visit.where(traffic_cop_id: ids).order(:created_at)
    data = []
    (0..6).each { |d| (0..23).each { |h| data << [d, h, 0] } }
    visits.each do |visit|
      h = visit.created_at.strftime('%k').to_i
      d = visit.created_at.strftime('%w').to_i
      data[(d * 24) + h][2] = data[(d * 24) + h][2] + (visit.duration / 60.0)
    end
    data
  end
  
  def self.visit_location_heatmap(ids)
    visits = Analyzable::Visit.includes(:detections).where(traffic_cop_id: ids).limit(1000)
    data = []
    256.times { |x| 256.times { |y| data << [x, y, 0] } }
    visits.each do |visit|
      visit.detections.each do |det|
        pos = {x: det.x, y: det.y}.transform_values(&:floor)
        pos[:x] = 255 if pos[:x] > 255
        pos[:y] = 255 if pos[:y] > 255
        data[(256 * pos[:x]) + pos[:y]][2] += 0.5
      end
    end
    { data: data, max: data.collect { |d| d[2] }.max }
  end
end