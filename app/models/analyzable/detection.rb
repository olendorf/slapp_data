class Analyzable::Detection < ApplicationRecord
  belongs_to :visit, class_name: 'Analyzable::Visit', optional: true
  
  attr_accessor :avatar_name, :avatar_key
end
