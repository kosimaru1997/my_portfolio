class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :introduction, length: { maximum: 140 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
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
  has_many :reposts, dependent: :destroy
  has_many :repost_posts, through: :reposts, source: :post
  attachment :image

  # 退会後のログインを禁止(deviseメソッド)
  def active_for_authentication?
    super && (self.activated == true)
  end

#ユーザー検索
  def self.search(search)
    User.where(['name LIKE ?', "%#{search}%"])
  end

  #ポストにいいねをする
  def favorite(post)
    favorites_posts << post
  end

  #いいねを解除
  def remove_favorite(post)
    favorites.find_by(post_id: post.id).destroy
  end

  #いいね済みか確認
  def favorited?(post)
    favorites.pluck(:post_id).include?(post.id)
  end

  #フォローする
  def follow(other_user)
    following << other_user
  end

  #フォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #フォロー済みか確認
  def following?(other_user)
    active_relationships.pluck(:followed_id).include?(other_user.id)
  end

  #リポスト
  def repost(post)
    repost_posts << post
  end

  #リポストを解除する
  def remove_repost(post)
    reposts.find_by(post_id: post.id).destroy
  end

  #リポスト済みか確認
  def reposted?(post)
    reposts.pluck(:post_id).include?(post.id)
  end

  #フォロー済みユーザーのポストを取得
  # def feed
  #   following_ids = self.following.select(:id)
  #   Post.where("user_id IN (:following_ids)
  #               OR user_id = :user_id", following_ids: following_ids, user_id: id)
  # end

  def posts_with_reposts
    relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND reposts.user_id = #{self.id}")
                   .select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.id)
            .or(relation.where("reposts.user_id = ?", self.id))
            .preload(:user)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END"))
  end

  def followings_posts_with_reposts
    relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND (reposts.user_id = #{self.id}
    OR reposts.user_id IN (SELECT followed_id FROM relationships WHERE follower_id = #{self.id}))")
                   .select("posts.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.followings_with_userself_ids )
            .or(relation.where(id: Repost.where(user_id: self.followings_with_userself_ids).pluck(:post_id)))
            .where("NOT EXISTS(SELECT 1 FROM reposts sub WHERE reposts.post_id = sub.post_id AND reposts.created_at < sub.created_at)")
            .preload(:user)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END"))
  end

  def followings_with_userself_ids
    ids = []
    ids = active_relationships.pluck(:followed_id)
    ids << id
  end
  # def zenbu
  #   follow_user_ids = self.following.select(:id)
  #     repost_ids = Repost.where("user_id IN (:follow_user_ids) OR user_id = :user_id",
  #                               follow_user_ids: follow_user_ids, user_id: self.id).select(:post_id)
  #     Post.where("id IN (:repost_ids) OR user_id IN (:follow_user_ids) OR user_id = :user_id",
  #                 repost_ids: repost_ids, follow_user_ids: follow_user_ids, user_id: self.id)
  # end

  #フォロー時の通知を作成
  def create_notification_follow!(current_user)
    # temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
      temp = Notification.where(visitor_id: current_user.id, visited_id: id, action: 'follow')
    if temp.blank?
      notification = current_user.active_notifications.new(visited_id: id, action: 'follow')
      notification.save if notification.valid?
    end
  end

  #未読の通知が存在するか確認(いいね、フォロー、コメント)
  def unchecked_notifications?
    passive_notifications.where(checked: false).any?
  end

  #未読の通知が存在するか確認(チャット)
  def unchecked_chats?
    my_rooms_ids = UserRoom.select(:room_id).where(user_id: id)
    other_user_ids = UserRoom.select(:user_id).where(room_id: my_rooms_ids).where.not(user_id: id)
    Chat.where(user_id: other_user_ids, room_id: my_rooms_ids).where.not(checked: true).any?
  end

end