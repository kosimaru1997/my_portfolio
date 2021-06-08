class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :user_rooms
  has_many :chats
  has_many :favorites, dependent: :destroy
  has_many :favorites_posts, through: :favorites, source: :post
  has_many :active_relationships, class_name:  "Relationship",
                                foreign_key: "follower_id", #followerがフォローする側
                                dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id", #followedがフォローされる側
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  attachment :image

  #フォロー済みか確認
  def following?(other_user)
    following.include?(other_user)
  end

  #フォロー済みユーザーのポストを取得
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  #フォロー時の通知を作成
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  #未読の通知が存在するか確認(いいね、フォロー、コメント)
  def unchecked_notifications?
    passive_notifications.where(checked: false).any?
  end
  
  #未読の通知が存在するか確認(いいね、フォロー、コメント)
  def unchecked_chats?
    my_rooms = UserRoom.select(:room_id).where(user_id: id)
    other_user_ids = UserRoom.select(:user_id).where(room_id: my_rooms).where.not(user_id: id)
    Chat.where(user_id: other_user_ids).where.not(checked: true).any?
  end

end