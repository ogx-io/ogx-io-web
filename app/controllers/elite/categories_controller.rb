class Elite::CategoriesController < ApplicationController
  before_action :set_elite_category, only: [:show]

  # GET /elite/categories/1
  # GET /elite/categories/1.json
  def show
    @children = @elite_category.children.normal.desc(:order).page(params[:page]).per(20)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elite_category
      @elite_category = Elite::Category.find(params[:id])
    end
end
