# frozen_string_literal: true

class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: %i[edit update destroy]
  before_action :ensure_normal_user, only: %i[confirm destroy]

  def index
    @users = if params[:search].nil?
               User.all.page(params[:page]).reverse_order
             else
               User.search(params[:search]).page(params[:page]).reverse_order
             end
    @login_user = User.includes(:active_relationships).find(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @login_user = User.includes(:favorites, :reposts).find(current_user.id)
    @posts = @user.posts_with_reposts.page(params[:page]).reverse_order
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      render action: 'edit'
    end
  end

  def confirm
    @user = User.find(params[:id])
  end

  def destroy
    current_user.destroy
    flash[:alert] = '退会完了。ご利用ありがとうございました。'
    redirect_to root_path
  end

  # ユーザー詳細画面から、ユーザーがフォローしているユーザーを表示
  def following
    @follow = 'follow' # cssスタイルを渡すための記述
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).order('relationships.created_at DESC')
    @login_user = current_user
  end

  # ユーザー詳細画面から、ユーザーにフォローされているユーザーを表示
  def followers
    @follower = 'follower' # CSSスタイルを渡すための
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).order('relationships.created_at DESC')
    @login_user = current_user
    render 'following'
  end

  # ユーザー詳細画面から、ユーザーがいいねしているポストを表示
  def favorites
    @user = User.find(params[:id])
    @posts = @user.favorites_posts.includes(:user).page(params[:page]).reverse_order
    @login_user = User.includes(:favorites).find(current_user.id)
    @favorites_posts = true
    render 'show'
  end

  def site
    @user = User.find(params[:id])
    @sites = @user.sites.page(params[:page]).per(10).reverse_order
  end

  private

  def ensure_normal_user
    redirect_to root_path, alert: 'ゲストユーザーの編集・削除はできません。' if current_user.email == 'guest@example.com'
  end

  def same_user!
    return if User.find_by(id: params[:id]) == current_user

    flash[:danger] = 'ユーザーにはアクセスする権限がありません'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end
end
