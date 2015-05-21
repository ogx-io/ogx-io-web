class Admin::SiteInfoController < ApplicationController

  layout 'admin'

  before_action :set_site_info

  def edit
  end

  def update
    authorize current_user, :admin?
    if @site_info.update(site_info_params)
      flash[:notice] = I18n.t('global.update_successfully')
    end
    redirect_to admin_site_info_edit_path
  end

  private

  def set_site_info
    @site_info = SiteInfo.get_instance
  end

  def site_info_params
    params[:site_info].permit(:about)
  end
end
