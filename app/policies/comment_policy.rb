class CommentPolicy < ApplicationPolicy

  def destroy?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.is_moderator?(user)
      is_supervisor = true
    end
    is_supervisor || record.user == user
  end

  def delete_all?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.is_moderator?(user)
      is_supervisor = true
    end
    is_supervisor
  end

  def resume?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.is_moderator?(user)
      is_supervisor = true
    end
    (is_supervisor && record.deleted == 2) || (user == record.user && record.deleted == 1)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

end
