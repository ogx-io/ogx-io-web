class NodePolicy < ApplicationPolicy

  def index?
    create?
  end

  def create?
    signed_in? && test_if_not(user.admin?, I18n.t('policies.common.no_permission'))
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
