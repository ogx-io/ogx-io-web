class BoardPolicy < NodePolicy
  def favor?
    signed_in?
  end

  def disfavor?
    signed_in?
  end

  def update?
    signed_in? && test_if_not(record.has_moderator?(user), I18n.t('policies.common.no_permission'))
  end

  def edit?
    update?
  end
end
