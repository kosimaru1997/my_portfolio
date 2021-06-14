class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_user!, only: [:destroy]

  def create
    @post = current_user.posts.build(post_params)
    unless @post.save
      render "shared/error"
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy if post
    redirect_back(fallback_location: root_path)
  end

  def index
    @post = current_user.posts.build
    @posts = Post.all.includes(:user, :favorites, :favorited_users, :post_comments).page(params[:page]).reverse_order
    if params[:search].present?
      @posts = Post.search(params[:search]).includes(:user, :favorites, :favorited_users, :post_comments).page(params[:page]).reverse_order
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
    @comment_reply = @post.post_comments.build
    @post_comment_count = @post.only_comment_count
    @post_comments = @post.post_comments.includes(:user).where(parent_id: nil).page(params[:page]).per(10).reverse_order
  end

#投稿に対していいねしたユーザーの一覧を取得、モーダルで(format js)"posts/_favorited_users"を表示。
  def favorited
    @post = Post.find(params[:id])
    @users = @post.favorited_users.page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
  end

  private

    def same_user!
      unless Post.find_by(id: params[:id]).user == current_user
        redirect_to request.referer
      end
    end

    def post_params
      params.require(:post).permit(:content)
    end

end
