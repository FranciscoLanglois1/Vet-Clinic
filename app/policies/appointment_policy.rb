class AppointmentPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def index?
    user.admin? || user.vet? || user.owner?
  end

  def show?
    user.admin? || (user.vet? && record.vet.user == user) || (user.owner? && record.pet.owner.user == user)
  end

  def create?
    user.admin? || user.vet? || user.owner?
  end

  def update?
    user.admin? ||  (user.vet? && record.vet.user == user)  || (user.owner? && record.pet.owner.user == user)
  end

  def destroy?
    user.admin? || (user.vet? && record.vet.user == user) || (user.owner? && record.pet.owner.user == user)
  end

  def permitted_attributes
    if user.admin?
      [:pet_id, :vet_id, :date, :reason, :status]
    elsif user.vet?
      [:vet_id, :date, :reason, :status]
    elsif user.owner?
      [:date, :reason, :status]
    else
      []
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.vet?
        scope.where(vet_id: user.vet.id)
      elsif user.owner?
        scope.joins(pet: :owner).where(owners: { user_id: user.id })
      else
        scope.none
      end
    end
  end
end
