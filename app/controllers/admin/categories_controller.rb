class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  layout 'admin'

  # GET /admin/categories/new
  def new
    @category = Category.new
    if params[:parent_id]
      @category.parent_id = params[:parent_id]
    end
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # POST /admin/categories
  # POST /admin/categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_nodes_path(parent_id: @category.parent_id) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/categories/1
  # PATCH/PUT /admin/categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_nodes_path(parent_id: @category.parent_id) }
        format.js { render 'admin/nodes/refresh', locals: { node: @category } }
      else
        format.html { render :edit }
        format.js { render 'admin/nodes/refresh', locals: { node: @category } }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params[:category].permit(:name, :path, :parent_id, :status)
    end
end
