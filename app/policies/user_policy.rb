class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def manage?
    @current_user.admin? || @current_user.managing_boards.count > 0
  end

  def index?
    @current_user.admin?
  end

  def show?
    true
  end

  def posts?
    true
  end

  def topics?
    true
  end

  def elites?
    true
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

  def collect_board?
    test_if_not(@current_user == @user, I18n.t('policies.common.no_permission'))
  end

  def uncollect_board?
    test_if_not(@current_user == @user, I18n.t('policies.common.no_permission'))
  end

end
