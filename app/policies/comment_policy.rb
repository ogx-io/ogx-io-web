class CommentPolicy < ApplicationPolicy

  def destroy?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.is_moderator?(user)
      is_supervisor = true
    end
    is_supervisor || record.user == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

end
