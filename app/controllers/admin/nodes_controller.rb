class Admin::NodesController < ApplicationController

  layout "admin"

  # GET /admin/nodes
  # GET /admin/nodes.json
  def index
    @all_nodes = Node.where(:_type.in => ['Category', 'Board'])
    @nodes = @all_nodes.asc(:parent_id, :order).page(params[:page]).per(25)
  end

end
