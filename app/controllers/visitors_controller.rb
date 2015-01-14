class VisitorsController < ApplicationController

  def index
    @topics = Topic.normal.desc(:replied_at).limit(30)
  end
end
