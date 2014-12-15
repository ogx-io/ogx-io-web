class VisitorsController < ApplicationController

  def index
    @posts = Post.normal.desc(:created_at).limit(15)
  end
end
