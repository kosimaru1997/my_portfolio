class Admin::PostCommentsController < ApplicationController

  def index
    @comments = PostComment.includes(:user).page(params[:page]).reverse_order
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end

end
