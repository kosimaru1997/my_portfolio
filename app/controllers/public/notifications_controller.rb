class Public::NotificationsController < ApplicationController

  def index
    notifications_all = current_user.passive_notifications
    notifications_all.where(checked: false).each do |notification| # .update_all(checked: true)
      notification.update_attributes(checked: true)
    end
    @notifications = notifications_all.includes(:post, :post_comment, :visitor, :visited)
                                      .where.not(visitor_id: current_user.id).page(params[:page])
  end

  def destroy
    Notification.find(params[:id]).destroy
    flash[:danger] = "通知を削除しました"
    redirect_to notifications_path
  end

  def destroy_all
    notifications_all = current_user.passive_notifications
    if notifications_all
      notifications_all.where(checked: true).each do |notification|
        notification.destroy
      end
      flash[:danger] = "全ての通知を削除しました"
    end
    redirect_to notifications_path
  end

end