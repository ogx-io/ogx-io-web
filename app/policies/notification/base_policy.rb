class Notification::BasePolicy < ApplicationPolicy

  def index?
    signed_in?
  end

  def destroy?
    signed_in? && test_if_not(user == record.user, '您没有访问权限')
  end

  def clean?
    signed_in?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
