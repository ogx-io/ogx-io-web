class Elite::PostPolicy < ApplicationPolicy

  def show?
    if record.deleted?
      signed_in? && (user.admin? || record.board.has_moderator?(user) || record.author == user)
    else
      true
    end
  end

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
