class VetPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || user.vet? || user.owner?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || (user.vet? && record.user == user)
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      [:first_name, :last_name, :email, :phone, :specialization, :user_id]
    elsif user.vet?
      [:first_name, :last_name, :email, :phone, :specialization]
    else
      []
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin? || user.vet? || user.owner?
        scope.all
      else
        scope.none
      end
    end
  end
end
