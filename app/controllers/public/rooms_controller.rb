class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :same_room_user!, only: [:show]

  def index
    my_rooms_ids = current_user.user_rooms.select(:room_id)
    @user_rooms = UserRoom.includes(:chats, :user).where(room_id: my_rooms_ids).where.not(user_id: current_user.id).reverse_order
  end

  def create
    @user = User.find(params[:user_id])
    user_rooms = UserRoom.find_user_rooms(current_user, @user)
    unless user_rooms.nil?
      room = user_rooms.room
    else
      room = Room.create
      UserRoom.create(user_id: current_user.id, room_id: room.id)
      UserRoom.create(user_id: @user.id, room_id: room.id)
    end
    redirect_to room_path(room.id)
  end

  def show
    room = Room.find(params[:id])
    room.check_chats_notification(current_user)
    user_id = room.user_rooms.where.not(user_id: current_user.id).select(:user_id)
    @user = User.where(id: user_id).first
    @chats = room.chats.includes(:user)
    @chat = Chat.new(room_id: room.id)
  end

  private

   def same_room_user!
     unless Room.find(params[:id]).users.include?(current_user)
       flash[:danger] = "ユーザーにはアクセスする権限がありません"
       redirect_to root_path
     end
   end

end