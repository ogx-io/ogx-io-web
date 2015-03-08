class Elite::PostPolicy < ApplicationPolicy

  def show?
    if record.deleted?
      signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user) || record.author == user), I18n.t('policies.common.no_permission'))
    else
      true
    end
  end

  def update?
    signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user)), I18n.t('policies.common.no_permission'))
  end

  def destroy?
    signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user) || record.author == user), I18n.t('policies.common.no_permission'))
  end

  def resume?
    signed_in? && test_if_not((((user.admin? || record.board.has_moderator?(user)) && record.deleted == 2) || (record.author == user && record.deleted == 1)), I18n.t('policies.common.no_permission'))
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
