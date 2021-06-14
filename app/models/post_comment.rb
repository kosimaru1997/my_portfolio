class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  belongs_to :parent,  class_name: "PostComment", optional: true, counter_cache: true
  has_many   :replies, class_name: "PostComment", foreign_key: :parent_id, dependent: :destroy

  validates :user_id, presence: true
  validates :comment, presence: true, length: { maximum: 140 }
end