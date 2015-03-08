class ApplicationPolicy
  attr_reader :user, :record
  attr_accessor :err_msg

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  protected

  def signed_in?
    test_if_not(user, I18n.t('policies.common.not_signed_in'))
  end

  def test_if_not(cond, msg)
    if !cond
      @err_msg = msg
      false
    else
      true
    end
  end

  def test_if(cond, msg)
    if cond
      @err_msg = msg
      false
    else
      true
    end
  end
end

