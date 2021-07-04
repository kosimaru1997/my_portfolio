# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :notifications, dependent: :destroy
  has_many :reposts, dependent: :destroy
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # リプライを除くコメント数を取得
  def only_comment_count
    post_comments.where(parent_id: nil).size
  end

  # 検索機能
  def self.search(search)
    Post.where(['content LIKE ?', "%#{search}%"])
  end

  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(visitor_id: current_user.id, visited_id: user_id, action: 'favorite')
    # いいねされていない場合のみ、通知レコードを作成
    return if temp.present?

    notification = current_user.active_notifications.new(post_id: id, visited_id: user_id, action: 'favorite')
    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_repost!(current_user)
    # すでに「リポスト」されているか検索
    temp = Notification.where(visitor_id: current_user.id, visited_id: user_id, action: 'repost')
    # リポストされていない場合のみ、通知レコードを作成
    return if temp.present?

    notification = current_user.active_notifications.new(post_id: id, visited_id: user_id, action: 'repost')
    # 自分の投稿に対するリポストの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id[:user_id])
    end
    # 投稿者に通知を送る
    save_notification_comment!(current_user, post_comment_id, user_id) unless temp_ids.pluck(:user_id).include?(user_id)
  end

  # リプライ用の通知。こちらの方が精度が高い（リプライしたコメントに紐ずくユーザーとポストの投稿者にのみ通知する）が,
  # 利用者が少ない段階では、幅広いユーザー（ポストに紐ずくユーザー全て）に通知を送り、アプリに触れる機会を増やす方が重要と思い使用していない。
  # def create_notification_replay!(current_user, replay)
  #   #自分以外にリプライしているユーザーを取得し、全員に通知を送る
  #   replies_ids = PostComment.select(:user_id).where(id: replay.parent_id).where.not(user_id: current_user.id).distinct
  #   replies_ids.each do |temp_id|
  #     save_notification_comment!(current_user, replay.id, temp_id[:user_id])
  #   end
  #   #投稿者に通知を送る
  #   save_notification_comment!(current_user, replay.id, user_id) unless temp_ids.pluck(:user_id).include?(user_id)
  # end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications
                               .new(post_id: id, post_comment_id: post_comment_id, visited_id: visited_id, action: 'comment')
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
