class Repost < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates_uniqueness_of :post_id, scope: :user_id
  
  # scope :laytest_by_post, -> {
  # laytest_reposts = 
  'SELECT t1.* FROM reposts AS t1
  INNER JOIN(SELECT post_id, MAX(created_at) AS maxDate 
  FROM reposts GROUP BY post_id) AS t2 
  ON t1.created_at = t2.maxdate AND t1.post_id = t2.post_id;'
  # }
  
end
