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
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
  end
  
  private
  
    def post_params
      params.require(:post).permit(:content)
    end
  
end
