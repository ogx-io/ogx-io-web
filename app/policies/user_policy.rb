class UserPolicy
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

  def deleted_posts?
    @current_user == @user
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

  def collect_board?
    @current_user == @user
  end

  def uncollect_board?
    @current_user == @user
  end

end
