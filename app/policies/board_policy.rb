class BoardPolicy < ApplicationPolicy

  def update?
    signed_in? && user.admin?
  end

  def create?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
