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
    rescue MetaInspector::RequestError,MetaInspector::ParserError => e
      logger.error e
      logger.error e.backtrace.join("\n")
      return render 'shared/url_error'
    end
    if @site.save
      redirect_to site_path(@site)
    else
      return render 'shared/validation_error'
    end
  end

  def destroy
    Site.find(params[:id]).destroy
    redirect_to site_top_path
  end

  def index
  end

  def show
    @site = Site.find(params[:id])
  end

  def edit
    @site = Site.find(params[:id])
  end
  
  def update
    @site = Site.find(params[:id])
    if @site.update(site_params)
      redirect_to site_path(@site)
    else
      render 'edit'
    end
  end
  
  def preview
    @note = view_context.markdown(params[:body])
  end

  private

  def site_params
    params.require(:site).permit(:url, :note)
  end

end
