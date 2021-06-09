class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :chats, through: :room

 #個別のルームに通知があるか確認（チャット）
  def massage_checked
    chats.where(user_id: user_id, checked: false).any?
  end

end
