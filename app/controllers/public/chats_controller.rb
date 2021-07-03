# frozen_string_literal: true

class Public::ChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.new(chat_params)
    if @chat.save
      redirect_to request.referer
    else
      render 'shared/error'
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
