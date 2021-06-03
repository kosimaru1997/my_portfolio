class Public::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
  end

  def update
    current_user.update(user_params)
    redirect_to user_path(current_user)
  end

  def destroy
    current_user.destroy
    flash[:alert] = "退会完了。ご利用ありがとうございました。"
    redirect_to root_path
  end

  def following
    @follow = "follow"
    @user = User.find(params[:id])
    @users = @user.following
    render "follow"
  end

  def followers
    @follower = "follower"
    @user = User.find(params[:id])
    @users = @user.followers
    render "follow"
  end

  def favorites
    @user = User.find(params[:id])
    @posts = @user.favorites_posts
    render "show"
  end

  private

    def user_params
      params.require(:user).permit(:name, :image)
    end

end
