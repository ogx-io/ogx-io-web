class CategoryPolicy < ApplicationPolicy

  def create?
    signed_in? && user.admin?
  end

  def update?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
