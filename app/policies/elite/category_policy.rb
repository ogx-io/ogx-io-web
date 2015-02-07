class Elite::CategoryPolicy < ApplicationPolicy

  def create?
    signed_in? && (user.admin? || record.parent.board.has_moderator?(user))
  end

  def update?
    signed_in? && (user.admin? || record.board.has_moderator?(user))
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
