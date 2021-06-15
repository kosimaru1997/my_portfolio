class Room < ApplicationRecord
  has_many :user_rooms
  has_many :chats
  
  #チャット通知を既読にするためのメゾット
  def check_chats_notification(current_user)
    unchecked_chats = chats.includes(:user).where(checked: false).where.not(user_id: current_user.id)
    unchecked_chats.each {|unchecked_chat| unchecked_chat.update_attributes(checked: true)} if unchecked_chats
  end
  
end
