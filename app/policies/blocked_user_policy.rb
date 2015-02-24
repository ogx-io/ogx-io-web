class BlockedUserPolicy < ApplicationPolicy

  def create?
    if record.blockable_type == "Board"
      return record.blockable.has_moderator?(user) || user.admin?
    end
    false
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
