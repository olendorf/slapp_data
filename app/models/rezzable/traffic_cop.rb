class Rezzable::TrafficCop < ApplicationRecord
  
  acts_as :abstract_web_object
  
  has_many :visits, class_name: 'Analyzable::Visit', dependent: :nullify
  
  attr_accessor :detection
  
  before_update :handle_detection!, if: :detection
  
  
  OBJECT_WEIGHT = 25
  
  def self.ransackable_associations(_auth_object = nil)
    %w[abstract_web_object actable user created_at]
  end
  
  def self.ransackable_attributes(_auth_object = nil)
    %w[id id_value]
  end
  
  private
  
  def handle_detection!
    atts = {
      avatar_name: detection.avatar_name, 
      avatar_key: detection.avatar_key,
      region: self.region,
      user_id: self.user_id
    }
    visit = Analyzable::Visit.create(atts)
    visit.detections << detection
    self.visits << visit
    self.detection = nil
  end
end
