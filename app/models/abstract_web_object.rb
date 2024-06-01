class AbstractWebObject < ApplicationRecord
    actable
    
    belongs_to :user, dependent: :destroy, touch: true, required: false
end
