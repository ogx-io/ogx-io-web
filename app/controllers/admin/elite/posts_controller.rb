class Admin::Elite::PostsController < ApplicationController
  before_action :set_elite_post, only: [:edit, :update]

  layout 'admin'

  # GET /admin/elite/posts/1/edit
  def edit
    authorize @elite_post
  end

  # PATCH/PUT /admin/elite/posts/1
  # PATCH/PUT /admin/elite/posts/1.json
  def update
    authorize @elite_post
    new_board = Elite::Category.find(params[:elite_post][:parent_id]).board
    old_board = @elite_post.board
    respond_to do |format|
      if new_board == old_board && @elite_post.update(elite_post_params)
        format.html { redirect_to admin_elite_nodes_path(parent_id: @elite_post.parent_id) }
      else
        if new_board != old_board
          @elite_post.errors.add(:parent_id, "Can not add me to another board!")
        end
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elite_post
      @elite_post = Elite::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def elite_post_params
      params[:elite_post].permit(:parent_id)
    end
end
