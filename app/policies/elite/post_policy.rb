class Elite::PostPolicy < ApplicationPolicy

  def update?
    signed_in? && (user.admin? || record.board.has_moderator?(user) || record.author == user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
