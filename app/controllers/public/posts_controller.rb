# frozen_string_literal: true

class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: [:destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'ポストを投稿しました'
      redirect_to root_path
    else
      # @login_user = current_user
      render 'shared/error'
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
    redirect_back(fallback_location: root_path)
  end

  def index
    @post = current_user.posts.build
    @posts = if params[:search].nil?
               Post.all.includes(:user).page(params[:page]).reverse_order
             else
               Post.search(params[:search]).includes(:user).page(params[:page]).reverse_order
             end
    @login_user = User.includes(:favorites).find(current_user.id)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @login_user = current_user
    @post_comment = PostComment.new
    @post_comment_count = @post.only_comment_count
    @post_comments = @post.post_comments.includes(:user).where(parent_id: nil).page(params[:page]).per(10).reverse_order
  end

  # 投稿に対していいねしたユーザーの一覧を取得、モーダルで(format js)"posts/_favorited_users"を表示。
  def favorited
    @post = Post.find(params[:id])
    @users = @post.favorited_users.reverse_order
    @login_user = User.includes(:active_relationships).find(current_user.id)
  end

  private

  def same_user!
    return if Post.find_by(id: params[:id]).user == current_user

    flash[:danger] = 'ユーザーにはアクセスする権限がありません'
    redirect_to root_path
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
