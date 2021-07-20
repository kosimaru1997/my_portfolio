# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :chats, through: :room
  validates :user_id, presence: true
  validates :room_id, presence: true

  # チャット相手とのルームを検索
  def self.find_user_rooms(current_user, other_user)
    rooms_ids = current_user.user_rooms.pluck(:room_id)
    UserRoom.find_by(user_id: other_user.id, room_id: rooms_ids)
  end

  # 個別のルームに未読の通知があるか確認（チャット）
  def massage_checked
    chats.where(user_id: user_id, checked: false).any?
  end
end
