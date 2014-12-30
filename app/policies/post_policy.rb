class PostPolicy < ApplicationPolicy

  def destroy?
    user && (record.board.is_moderator?(user) || record.author == user)
  end

  def resume?
    user && record.board.is_moderator?(user)
  end

  def create?
    user && user.can_post? && !record.board.is_blocked?(user)
  end

  def update?
    user == record.author
  end

  def toggle?
    resume?
  end

  def comment?
    user && user.can_comment? && !record.board.is_blocked?(user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
