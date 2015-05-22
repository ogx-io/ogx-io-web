class BoardPolicy < NodePolicy
  def favor?
    signed_in?
  end

  def disfavor?
    signed_in?
  end

  def update?
    record.has_moderator?(user)
  end

  def edit?
    update?
  end
end
