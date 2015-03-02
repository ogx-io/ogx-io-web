class Elite::PostsController < ApplicationController
  before_action :set_elite_post, only: [:show, :destroy, :resume]

  # GET /elite/posts/1
  # GET /elite/posts/1.json
  def show
    authorize @elite_post
  end

  # DELETE /elite/posts/1
  # DELETE /elite/posts/1.json
  def destroy
    authorize @elite_post
    @elite_post.delete_by(current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  def resume
    authorize @elite_post
    @elite_post.resume_by(current_user)
    respond_to do |format|
      format.js { render 'refresh' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elite_post
      @elite_post = Elite::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def elite_post_params
      params[:elite_post]
    end
end
