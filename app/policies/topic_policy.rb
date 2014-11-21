class TopicPolicy < ApplicationPolicy

  def update?
    record.board.is_moderator?(user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
