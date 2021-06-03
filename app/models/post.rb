class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  #favorite済みの場合
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
