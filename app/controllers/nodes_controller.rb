class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @nodes = Node.all
    respond_with(@nodes)
  end

  def show
    respond_with(@node)
  end

  def new
    @node = Node.new
    respond_with(@node)
  end

  def edit
  end

  def create
    @node = Node.new(node_params)
    @node.save
    respond_with(@node)
  end

  def update
    @node.update(node_params)
    respond_with(@node)
  end

  def destroy
    @node.destroy
    respond_with(@node)
  end

  private
    def set_node
      @node = Node.find(params[:id])
    end

    def node_params
      params[:node]
    end
end
