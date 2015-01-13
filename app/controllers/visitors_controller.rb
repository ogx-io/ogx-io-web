class VisitorsController < ApplicationController

  def index
    @topics = Topic.normal.desc(:replied_at).limit(15)
  end
end
