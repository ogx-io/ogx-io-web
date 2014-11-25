class BoardPolicy < ApplicationPolicy

  def blocked_users?
    record.is_moderator?(user)
  end

  def update?
    user && user.admin?
  end

  def create?
    update?
  end

  def manage?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
