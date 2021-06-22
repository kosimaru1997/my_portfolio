class Repost < ApplicationRecord
  belongs_to :user
  belongs_to :post
  counter_culture :post
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates_uniqueness_of :post_id, scope: :user_id
end