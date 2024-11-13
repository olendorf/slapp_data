class Analyzable::Visit < ApplicationRecord
  belongs_to :user
  belongs_to :traffic_cop, class_name: 'Rezzable::TrafficCop'
  has_many :detections, class_name: 'Analyzable::Detection', dependent: :destroy
end
