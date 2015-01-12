class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]

  respond_to :json

  def create
    @picture = Picture.new(picture_params)
    @picture.picturable_id = @picture.picturable_id.to_i
    @picture.user = current_user
    @picture.save
    respond_with(@picture)
  end

  def destroy
    @picture.destroy
    respond_with(@picture)
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def picture_params
      params[:picture].permit(:picturable_type, :picturable_id, :image)
    end
end
