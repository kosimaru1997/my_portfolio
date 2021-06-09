class Public::ChatsController < ApplicationController

  def index
    my_rooms = current_user.user_rooms.select(:room_id)
    @rooms = UserRoom.includes(:chats, :user).where(room_id: my_rooms).where.not(user_id: current_user.id).reverse_order
  end

  def show
    @user = User.find(params[:user_id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    unless user_rooms.nil?
      @room = user_rooms.room
      #通知を既読にするためのメソッド
      chats = @room.chats.includes(:user).where(checked: false).where.not(user_id: current_user.id)
      chats.each {|check| check.update_attributes(checked: true)}
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats.includes(:user)
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end
