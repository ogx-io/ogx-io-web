class Admin::Elite::CategoriesController < ApplicationController
  before_action :set_elite_category, only: [:edit, :update, :destroy]

  layout 'admin'

  # GET /admin/elite/categories/new
  def new
    @elite_category = Elite::Category.new
    @elite_category[:parent_id] = params[:parent_id]
    @elite_category.board = @elite_category.parent.board
    authorize @elite_category
  end

  # GET /admin/elite/categories/1/edit
  def edit
    authorize @elite_category
  end

  # POST /admin/elite/categories
  # POST /admin/elite/categories.json
  def create
    @elite_category = Elite::Category.new(elite_category_params)
    @elite_category[:parent_id] = @elite_category[:parent_id].to_i
    @elite_category.board = @elite_category.parent.board

    authorize @elite_category

    @elite_category.moderator = current_user
    respond_to do |format|
      if @elite_category.save
        format.html { redirect_to admin_elite_nodes_path(parent_id: @elite_category[:parent_id]) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/elite/categories/1
  # PATCH/PUT /admin/elite/categories/1.json
  def update
    authorize @elite_category

    @elite_category.update(elite_category_params)
    @elite_category[:parent_id] = @elite_category[:parent_id].to_i
    @elite_category.moderator = current_user
    respond_to do |format|
      if @elite_category.save
        format.html { redirect_to admin_elite_nodes_path(parent_id: @elite_category[:parent_id]) }
      else
        format.html { render :edit }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_elite_category
    @elite_category = Elite::Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def elite_category_params
    params[:elite_category].permit(:title, :parent_id)
  end
end
