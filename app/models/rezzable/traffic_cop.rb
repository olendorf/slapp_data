class Rezzable::TrafficCop < ApplicationRecord
  
  acts_as :abstract_web_object
  
  has_many :visits, class_name: 'Analyzable::Visit', dependent: :nullify
  
  
  OBJECT_WEIGHT = 25
  
  def self.ransackable_associations(_auth_object = nil)
    %w[abstract_web_object actable user created_at]
  end
  
  def self.ransackable_attributes(_auth_object = nil)
    %w[id id_value]
  end
end
