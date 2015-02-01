class Admin::NodesController < ApplicationController

  layout "admin"

  # GET /admin/nodes
  # GET /admin/nodes.json
  def index
    @all_nodes = Node.all
    @nodes = @all_nodes.asc(:path).page(params[:page]).per(25)
  end

end
