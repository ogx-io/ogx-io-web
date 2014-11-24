class TopicPolicy < ApplicationPolicy

  def show?
    !record.is_deleted? || record.board.is_moderator?(user)
  end

  def update?
    record.board.is_moderator?(user)
  end

  def destroy?
    update?
  end

  def resume?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
