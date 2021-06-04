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
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end
  
  def favorited
    @post = Post.find(params[:id])
    @users = @post.favorited_users
    # render "public/users/index"
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

end
