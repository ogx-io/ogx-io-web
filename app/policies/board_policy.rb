class BoardPolicy < ApplicationPolicy

  def blocked_users?
    record.is_moderator?(user)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
