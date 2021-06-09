class Public::PostsController < ApplicationController

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "コメントを投稿しました"
      redirect_to root_url
    else
      render 'homes/top.html.erb'
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
    @post_comments = @post.post_comments.where(parent_id: nil).includes(:user).page(params[:page]).reverse_order
  end

  def favorited
    @post = Post.find(params[:id])
    @users = @post.favorited_users.page(params[:page]).reverse_order
    @login_user = User.includes(:following).find(current_user.id)
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

end
