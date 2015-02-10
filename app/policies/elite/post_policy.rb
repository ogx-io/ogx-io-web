class Elite::PostPolicy < ApplicationPolicy

  def update?
    signed_in? && (user.admin? || record.board.has_moderator?(user))
  end

  def destroy?
    signed_in? && (user.admin? || record.board.has_moderator?(user) || record.author == user)
  end

  def resume?
    signed_in? && (user.admin? || record.board.has_moderator?(user) || (record.author == user && record.deleted == 1))
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
