class CommentPolicy < ApplicationPolicy

  def destroy?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.has_moderator?(user)
      is_supervisor = true
    end
    signed_in? && (is_supervisor || record.user == user || user.admin?)
  end

  def delete_all?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.has_moderator?(user)
      is_supervisor = true
    end
    signed_in? && (is_supervisor || user.admin?)
  end

  def resume?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.has_moderator?(user)
      is_supervisor = true
    end
    signed_in? && ((is_supervisor && record.deleted == 2) || (user == record.user && record.deleted == 1) || (user.admin? && record.deleted == 3))
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

end
