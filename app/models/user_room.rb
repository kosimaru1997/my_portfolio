class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :chats, through: :room
  has_many :caht_for_notice, through: :user, source: :chats #相手のユーザからのチャットのみを取得
end
