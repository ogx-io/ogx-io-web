class PostPolicy < ApplicationPolicy

  def destroy?
    record.board.is_moderator?(user) || record.author == user
  end

  def resume?
    record.board.is_moderator?(user)
  end

  def create?
    !record.board.is_blocked?(user)
  end

  def update?
    create?
  end

  def toggle?
    resume?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
