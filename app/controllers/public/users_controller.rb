class Public::UsersController < ApplicationController

  def index
    @users = User.all.page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @login_user = User.includes(:following).find(current_user.id)
    @posts = @user.posts.page(params[:page]).reverse_order
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
    @follow = "follow" #cssスタイルを渡すための記述
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
    render "follow"
  end

  def followers
    @follower = "follower" #CSSスタイルを渡すための
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
    render "follow"
  end

  def favorites
    @user = User.find(params[:id])
    @posts = @user.favorites_posts.includes(:user).page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
    render "show"
  end

  private

    def user_params
      params.require(:user).permit(:name, :image)
    end

end
