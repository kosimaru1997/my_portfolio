class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)   #active_relationships.create(followed_id: params[:user_id])
    begin
      @user.create_notification_follow!(current_user)
    rescue => e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
    #フォロー完了後のログインユーザーのフォロー情報を取得し条件分岐で使用。
    @login_user = User.includes(:following).find(current_user.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    @login_user = User.includes(:following).find(current_user.id)
  end

end
