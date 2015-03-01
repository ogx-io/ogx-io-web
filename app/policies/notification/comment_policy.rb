class Notification::CommentPolicy < Notification::BasePolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
