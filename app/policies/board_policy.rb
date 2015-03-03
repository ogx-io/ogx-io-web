class BoardPolicy < ApplicationPolicy

  def update?
    signed_in? && test_if_not(user.admin?, '您没有此操作的权限')
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
