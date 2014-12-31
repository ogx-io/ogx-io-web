class BoardPolicy < ApplicationPolicy

  def blocked_users?
    signed_in? && record.is_moderator?(user)
  end

  def update?
    signed_in? && user.admin?
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
