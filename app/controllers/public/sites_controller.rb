class Public::SitesController < ApplicationController

  def site_top
    @site = Site.new
    @sites = current_user.following_sites.includes(:user).page(params[:page]).reverse_order
    @login_user = current_user
  end

  def new
    @site = Site.new
  end

  def create
    @site = current_user.sites.new(site_params)
    if @site.url.empty?
      return render 'shared/url_error'
    end

    begin
      @site.get_site_info
    rescue OpenURI::HTTPError, Errno::ENOENT => e
      logger.error e
      logger.error e.backtrace.join("\n")
      return render 'shared/url_error'
    end
    if @site.save
      redirect_back(fallback_location: root_path)
    else
      return render 'shared/validation_error'
    end
  end

  def destroy
    Site.find(params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end

  def index
  end

  def show
  end

  def edit
  end

  private

  def site_params
    params.require(:site).permit(:url, :note)
  end

end
