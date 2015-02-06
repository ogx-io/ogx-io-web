class Admin::Elite::NodesController < ApplicationController

  layout 'admin'

  # GET /admin/elite/nodes
  # GET /admin/elite/nodes.json
  def index
    if params[:parent_id].blank?
      @all_nodes = Elite::Node.where(layer: 0)
    else
      @parent = Elite::Node.find(params[:parent_id])
      @all_nodes = Elite::Node.where(parent_id: params[:parent_id])
    end
    @nodes = @all_nodes.desc(:order).page(params[:page]).per(20)
  end
end
