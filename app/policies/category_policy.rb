class CategoryPolicy < ApplicationPolicy

  def create?
    signed_in? && test_if_not(user.admin?, '您没有权限做此操作')
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
