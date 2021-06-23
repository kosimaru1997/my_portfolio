class InquiryController < ApplicationController
  def index
    # 入力画面を表示
    if params[:inquiry]
      @inquiry = Inquiry.new(inquiry_params)
    else
      @inquiry = Inquiry.new
      if current_user
        @inquiry.name = current_user.name
        @inquiry.email = current_user.email
      end
    end
  end

  def confirm
    # 入力値のチェック
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.valid?
      # OK。確認画面を表示
      render action: 'confirm'
    else
      # NG。入力画面を再表示
      render action: 'index'
    end
  end

  def thanks
    # メール送信
    @inquiry = Inquiry.new(inquiry_params)
    byebug
    InquiryMailer.received_email(@inquiry).deliver_now

    # 完了画面を表示
    render action: 'thanks'
  end

  private
    def inquiry_params
      params.require(:inquiry).permit(:name, :email, :message)
    end
end