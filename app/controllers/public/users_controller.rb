class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
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

  private

    def user_params
      params.require(:user).permit(:name, :image)
    end

end
