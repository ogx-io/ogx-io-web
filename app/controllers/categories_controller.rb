class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  respond_to :html

  def show
    respond_with(@category)
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

end
