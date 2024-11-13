class Analyzable::Visit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :traffic_cop, class_name: 'Rezzable::TrafficCop', optional: true
  has_many :detections, class_name: 'Analyzable::Detection', 
                        dependent: :destroy, 
                        after_add: :update_data
                        
  
  
  private
  
  def update_data(detection)
    self.avatar_name ||= detection.avatar_name
    self.avatar_key ||= detection.avatar_key
    self.duration = detection.created_at - self.created_at
  end
end
