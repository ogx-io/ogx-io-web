class NodesController < ApplicationController
  include NodeShowing

  before_action :set_node, only: [:show]

  def show
    show_node(@node)
  end

  def set_node
    path = params[:node_path]
    @node = Node.get_node_by_path(path) if path
  end

end