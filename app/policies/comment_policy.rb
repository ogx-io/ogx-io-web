class CommentPolicy < ApplicationPolicy

  def destroy?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.has_moderator?(user)
      is_supervisor = true
    end
    signed_in? && test_if_not(is_supervisor || record.user == user || user.admin?, I18n.t('policies.common.no_permission'))
  end

  def resume?
    is_supervisor = false
    if record.commentable_type == 'Post' && record.commentable.board.has_moderator?(user)
      is_supervisor = true
    end
    signed_in? && test_if_not(((is_supervisor && record.deleted == 2) || (user == record.user && record.deleted == 1 && !user.is_blocked? && !record.commentable.board.is_blocking?(user)) || (user.admin? && record.deleted == 2)), I18n.t('policies.common.no_permission'))
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

end
