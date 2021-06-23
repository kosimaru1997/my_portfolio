class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates :name, presence: {:message => '名前を入力してください'}, length: { maximum: 30, :message => '名前は30文字以下に設定してください' }
  validates :email, presence: {:message => 'メールアドレスを入力してください'}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX, :message => 'メールアドレスは有効ではありません'},
                    length: { maximum: 255 }
end