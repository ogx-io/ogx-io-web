class Elite::CategoriesController < ApplicationController
  before_action :set_elite_category, only: [:show, :edit, :update, :destroy]

  # GET /elite/categories/1
  # GET /elite/categories/1.json
  def show
    @children = @elite_category.children.normal.desc(:order).page(params[:page]).per(20)
  end

  # GET /elite/categories/new
  def new
    @elite_category = Elite::Category.new
  end

  # GET /elite/categories/1/edit
  def edit
  end

  # POST /elite/categories
  # POST /elite/categories.json
  def create
    @elite_category = Elite::Category.new(elite_category_params)

    respond_to do |format|
      if @elite_category.save
        format.html { redirect_to @elite_category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @elite_category }
      else
        format.html { render :new }
        format.json { render json: @elite_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elite/categories/1
  # PATCH/PUT /elite/categories/1.json
  def update
    respond_to do |format|
      if @elite_category.update(elite_category_params)
        format.html { redirect_to @elite_category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @elite_category }
      else
        format.html { render :edit }
        format.json { render json: @elite_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elite/categories/1
  # DELETE /elite/categories/1.json
  def destroy
    @elite_category.destroy
    respond_to do |format|
      format.html { redirect_to elite_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elite_category
      @elite_category = Elite::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def elite_category_params
      params[:elite_category]
    end
end
