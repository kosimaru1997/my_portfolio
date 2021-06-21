class Public::ChatsController < ApplicationController
 before_action :authenticate_user!
#下記コメントアウトはエラーが発生した時のために、一時的に保存しておきます。
  # def index
  #   my_rooms = current_user.user_rooms.select(:room_id)
  #   @rooms = UserRoom.includes(:chats, :user).where(room_id: my_rooms).where.not(user_id: current_user.id).reverse_order
  # end

  # def show
  #   @user = User.find(params[:user_id])
  #   user_rooms = UserRoom.find_user_rooms(current_user, @user)
  #   unless user_rooms.nil?
  #     room = user_rooms.room
  #     room.check_chats_notification(current_user)
  #   else
  #     room = Room.create
  #     UserRoom.create(user_id: current_user.id, room_id: room.id)
  #     UserRoom.create(user_id: @user.id, room_id: room.id)
  #   end
  #   @chats = room.chats.includes(:user)
  #   @chat = Chat.new(room_id: room.id)
  # end

  def create
    @chat = current_user.chats.new(chat_params)
    if @chat.save
      redirect_to request.referer
    else
      render "shared/error"
    end
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end
