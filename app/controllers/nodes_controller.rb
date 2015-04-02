class NodesController < ApplicationController

  def show
    path = params[:node_path]
    node = Node.get_node_by_path(path)
    if node.class == Category
      @category = node
      render 'categories/show'
    else
      @board = node
      @all_topics = @board.topics.normal
      @topics = @all_topics.desc(:replied_at).page(params[:page]).per(15)
      @top_posts = @board.posts.top.desc(:top)
      render 'topics/index'
    end
  end

end