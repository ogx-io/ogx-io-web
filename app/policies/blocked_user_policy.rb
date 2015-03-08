class BlockedUserPolicy < ApplicationPolicy

  def create?
    if record.blockable_type == "Board"
      return signed_in? && test_if_not(record.blockable.has_moderator?(user) || user.admin?, I18n.t('policies.common.no_permission'))
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
