class BlockedUserPolicy < ApplicationPolicy

  def create?
    if record.blockable_type == "Board"
      return signed_in? && test_if_not(record.blockable.has_moderator?(user) || user.admin?, '您没有权限进行此操作')
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
