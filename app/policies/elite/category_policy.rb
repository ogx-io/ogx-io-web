class Elite::CategoryPolicy < ApplicationPolicy

  def create?
    signed_in? && test_if_not(user.admin? || record.board.has_moderator?(user), '您没有权限进行此操作')
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
