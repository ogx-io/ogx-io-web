class Admin::Elite::CategoriesController < ApplicationController
  before_action :set_admin_elite_category, only: [:show, :edit, :update, :destroy]

  # GET /admin/elite/categories
  # GET /admin/elite/categories.json
  def index
    @admin_elite_categories = Admin::Elite::Category.all
  end

  # GET /admin/elite/categories/1
  # GET /admin/elite/categories/1.json
  def show
  end

  # GET /admin/elite/categories/new
  def new
    @admin_elite_category = Admin::Elite::Category.new
  end

  # GET /admin/elite/categories/1/edit
  def edit
  end

  # POST /admin/elite/categories
  # POST /admin/elite/categories.json
  def create
    @admin_elite_category = Admin::Elite::Category.new(admin_elite_category_params)

    respond_to do |format|
      if @admin_elite_category.save
        format.html { redirect_to @admin_elite_category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @admin_elite_category }
      else
        format.html { render :new }
        format.json { render json: @admin_elite_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/elite/categories/1
  # PATCH/PUT /admin/elite/categories/1.json
  def update
    respond_to do |format|
      if @admin_elite_category.update(admin_elite_category_params)
        format.html { redirect_to @admin_elite_category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_elite_category }
      else
        format.html { render :edit }
        format.json { render json: @admin_elite_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/elite/categories/1
  # DELETE /admin/elite/categories/1.json
  def destroy
    @admin_elite_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_elite_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_elite_category
      @admin_elite_category = Admin::Elite::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_elite_category_params
      params[:admin_elite_category]
    end
end
