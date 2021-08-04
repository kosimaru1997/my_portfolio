class Public::SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = current_user.sites.new(site_params)
    if @site.url.empty?
      flash.now[:danger] = "URLを入力してください。"
      return render :new 
    end

    begin
      @site.get_site_info
    rescue OpenURI::HTTPError
      flash.now[:danger] = "URLが間違っています。"
      return render :new
    end
    if @site.save
      redirect_to root_path
    else
      render :new
    end
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
