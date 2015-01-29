class PostPolicy < ApplicationPolicy

  def show?
    test_if(record.deleted? && (!user || record.author != user || !record.board.is_moderator?(user)), "该帖子已被删除，您无权查看。")
  end

  def destroy?
    signed_in? && (record.board.is_moderator?(user) || record.author == user)
  end

  def resume?
    signed_in? && record.board.is_moderator?(user)
  end

  def new?
    signed_in? &&
        test_if(record.parent && !record.parent.topic.can_reply_by(user), "所在主题已经被加锁，您不能回复了。") &&
        test_if(user.blocked?, "您的已经被全站封禁！") &&
        test_if(record.board.is_blocking?(user), "您已经被版主关进小黑屋，不能在本版发帖了。")
  end

  def create?
    signed_in? &&
        test_if(record.parent && !record.parent.topic.can_reply_by(user), "所在主题已经被加锁，您不能回复了。") &&
        test_if_not(user.can_post?, "您的发帖速度太快了，先休息一会儿吧。") &&
        test_if(user.blocked?, "您的已经被全站封禁！") &&
        test_if(record.board.is_blocking?(user), "您已经被版主关进小黑屋，不能在本版发帖了。")
  end

  def update?
    signed_in? &&
        test_if_not(user == record.author, "您不是作者本人，不能修改帖子。") &&
        test_if(user.blocked?, "您的已经被全站封禁！") &&
        test_if(record.board.is_blocking?(user), "您已经被版主关进小黑屋，不能在本版发帖了。")
  end

  def toggle?
    resume?
  end

  def comment?
    signed_in? &&
        test_if_not(user.can_comment?, "您的评论发得太快了，先休息一会儿吧。") &&
        test_if(user.blocked?, "您的已经被全站封禁！") &&
        test_if(record.board.is_blocking?(user), "您已经被版主关进小黑屋，不能在本版发评论了。")
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
