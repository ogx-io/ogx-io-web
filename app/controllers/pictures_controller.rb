class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]

  def create
    @picture = Picture.new
    begin
      authorize @picture
    rescue
      render text: ''
      return
    end

    @picture.image = params[:Filedata]
    @picture.user = current_user
    @picture.save
    current_user.update(last_upload_image_at: Time.now)
    render text: @picture.image.url
  end

end
