class Api::V1::ListableAvatarPolicy < ApplicationPolicy
  
  def create?
    false
  end
  
  def index?
    true
  end
end
