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
    @user == @current_user
  end

  def edit_info?
    update?
  end

  def edit_avatar?
    update?
  end

  def edit_accounts?
    update?
  end

  def edit_self_intro?
    update?
  end

  def update_self_intro?
    update?
  end

  def unbind_account?
    update?
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

end
