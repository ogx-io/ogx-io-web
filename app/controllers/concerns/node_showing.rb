module NodeShowing
  extend ActiveSupport::Concern

  private

  def show_node(node)
    if node.class == Category
      @category = node
      render 'categories/show'
    else
      @board = node
      if @board.is_blog?
        @user = @board.creator
        @all_posts = @board.posts.normal
        @posts = @all_posts.desc(:created_at).page(params[:page]).per(10)
        render 'boards/show_blog'
      else
        @all_topics = @board.topics.normal
        @topics = @all_topics.desc(:replied_at).page(params[:page]).per(15)
        @top_posts = @board.posts.top.desc(:top)
        render 'topics/index'
      end
    end
  end
end