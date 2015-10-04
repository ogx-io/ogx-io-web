class PostPolicy < ApplicationPolicy

  def show?
    test_if(record.deleted? && !(record.author == user || record.board.has_moderator?(user) || user.admin?), I18n.t('policies.common.no_permission'))
  end

  def destroy?
    signed_in? && test_if_not((record.board.has_moderator?(user) || record.author == user || user.admin?), I18n.t('policies.common.no_permission')) && test_if(record.deleted?, I18n.t('policies.post.post_has_been_deleted'))
  end

  def resume?
    signed_in? && test_if_not((((user.admin? || record.board.has_moderator?(user)) && record.deleted == 2) || (record.author == user && record.deleted == 1 && !user.is_blocked? && !record.board.is_blocking?(user))), I18n.t('policies.common.no_permission'))
  end

  def new?
    signed_in? &&
        test_if(record.parent && !record.parent.topic.can_reply_by(user), I18n.t('policies.post.topic_is_locked')) &&
        test_if(user.is_blocked?, I18n.t('policies.common.user_is_blocked_by_admin')) &&
        test_if(record.board.is_blocking?(user), I18n.t('policies.common.user_is_blocked_by_moderator')) &&
        test_if(record.board.is_blog? && user != record.board.creator, I18n.t('policies.common.no_permission'))
  end

  def create?
    signed_in? &&
        test_if(record.parent && !record.parent.topic.can_reply_by(user), I18n.t('policies.post.topic_is_locked')) &&
        test_if_not(user.can_post?, I18n.t('policies.post.post_too_fast')) &&
        test_if(user.is_blocked?, I18n.t('policies.common.user_is_blocked_by_admin')) &&
        test_if(record.board.is_blocking?(user), I18n.t('policies.common.user_is_blocked_by_moderator')) &&
        test_if(record.board.is_blog? && user != record.board.creator, I18n.t('policies.common.no_permission'))
  end

  def update?
    signed_in? &&
        test_if_not(user == record.author, I18n.t('policies.common.no_permission')) &&
        test_if(user.is_blocked?, I18n.t('policies.common.user_is_blocked_by_admin')) &&
        test_if(record.board.is_blocking?(user), I18n.t('policies.common.user_is_blocked_by_moderator'))
  end

  def set_elite?
    record.board.has_moderator?(user) || user.admin?
  end

  def unset_elite?
    destroy?
  end

  def top_up?
    set_elite?
  end

  def top_clear?
    set_elite?
  end

  def comment?
    signed_in? &&
        test_if_not(user.can_comment?, I18n.t('policies.post.comment_too_fast')) &&
        test_if(user.is_blocked?, I18n.t('policies.common.user_is_blocked_by_admin')) &&
        test_if(record.board.is_blocking?(user), I18n.t('policies.common.user_is_blocked_by_moderator'))
  end

  def like?
    signed_in?
  end

  def dislike?
    signed_in?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
