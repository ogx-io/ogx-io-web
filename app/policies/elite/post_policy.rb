class Elite::PostPolicy < ApplicationPolicy

  def show?
    if record.deleted?
      signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user) || record.author == user), '您没有查看权限')
    else
      true
    end
  end

  def update?
    signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user)), '您没有修改权限')
  end

  def destroy?
    signed_in? && test_if_not((user.admin? || record.board.has_moderator?(user) || record.author == user), '您没有此操作权限')
  end

  def resume?
    signed_in? && test_if_not((((user.admin? || record.board.has_moderator?(user)) && record.deleted == 2) || (record.author == user && record.deleted == 1)), '您没有此操作权限')
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
