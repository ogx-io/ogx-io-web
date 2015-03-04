class Admin::NodesController < ApplicationController
  before_action :set_node, only: [:order_up, :order_down]

  layout "admin"

  # GET /admin/nodes
  # GET /admin/nodes.json
  def index
    authorize Node
    if params[:parent_id]
      @all_nodes = Node.where(parent_id: params[:parent_id])
      @parent = Node.find(params[:parent_id])
    else
      @all_nodes = Node.where(layer: 0)
    end
    @nodes = @all_nodes.order_by(layer: 1, parent_id: 1, _type: 1, order: -1).page(params[:page]).per(25)
  end

  def order_up
    authorize @node, :update?
    @node.order += 1
    @node.save
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def order_down
    authorize @node, :update?
    @node.order -= 1
    @node.save
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def set_node
    @node = Node.find(params[:id])
  end
end
