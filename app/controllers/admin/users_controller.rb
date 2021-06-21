class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def top
    if params[:search].present?
      @users = User.search(params[:search]).page(params[:page]).reverse_order
    else
      @users = User.all.page(params[:page]).reverse_order
    end
  end

  def show
    @user = User.find(params[:id])
    if params[:comment] == "true"
      @comments = @user.post_comments.page(params[:page]).reverse_order
    else
      @posts = @user.posts.page(params[:page]).reverse_order
    end
  end

  def down
    User.find(params[:id]).update( activated: "false")
    redirect_to admin_root_path
  end

  def up
    User.find(params[:id]).update( activated: "true")
    redirect_to admin_root_path
  end
  def destroy
    User.find(params[:id]).destroy
  end

end