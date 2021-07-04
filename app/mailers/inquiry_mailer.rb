# frozen_string_literal: true

class InquiryMailer < ApplicationMailer
  default from: 'no_reply@example.com' # 送信元アドレス

  def received_email(inquiry)
    @inquiry = inquiry
    mail to: inquiry.email, subject: 'お問い合わせを承りました'
  end
end
