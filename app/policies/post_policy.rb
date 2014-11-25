class PostPolicy < ApplicationPolicy

  def destroy?
    record.board.is_moderator?(user) || record.author == user
  end

  def resume?
    record.board.is_moderator?(user) && user
  end

  def create?
    !record.board.is_blocked?(user) && user
  end

  def update?
    create? && user
  end

  def toggle?
    resume? && user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
