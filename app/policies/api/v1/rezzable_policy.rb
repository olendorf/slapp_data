class Api::V1::RezzablePolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def create?
    return true if @user.can_be_owner?
    begin
      object_weight = @record.class::OBJECT_WEIGHT
    rescue StandardError
      object_weight = @record::OBJECT_WEIGHT
    end
    @user.check_object_weight?(object_weight)
  end 
  
  def show?
    true
  end
  
  def update?
    @user.active?
  end
  
  def destroy?
    show?
  end
end
