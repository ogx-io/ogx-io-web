class BoardPolicy < NodePolicy
  def favor?
    signed_in?
  end

  def disfavor?
    signed_in?
  end
end
