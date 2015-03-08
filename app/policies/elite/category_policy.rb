class Elite::CategoryPolicy < ApplicationPolicy

  def create?
    signed_in? && test_if_not(user.admin? || record.board.has_moderator?(user), I18n.t('policies.common.no_permission'))
  end

  def update?
    create?
  end

  def resume?
    create?
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
