class PicturePolicy < ApplicationPolicy

  def create?
    user.can_upload_image?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
