class User < ApplicationRecord
  has_many :games
  has_many :reviews, dependent: :destroy
  has_many :recruitments, dependent: :destroy

  has_one_attached :profile_image

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  validates :self_introduction, length: { maximum: 1000 }
  validate :validate_profile_image

  #activatedがtrueのユーザー一覧を返す
  scope :activated_user, -> { where(activated: true) }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したら true を返す
   def authenticated?(attribute, token)
     digest = send("#{attribute}_digest")
     digest ?  BCrypt::Password.new(digest).is_password?(token) :
     false
   end

   # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # profile_image画像のバリデーション
  def validate_profile_image
    if profile_image.attached?
      if profile_image.blob.byte_size > 2.megabytes
        profile_image.purge
        errors.add(:profile_image, "は2メガバイト以下の画像を指定して下さい")
      elsif !image?
        profile_image.purge
        errors.add(:profile_image, "はイメージファイルを指定して下さい")
      end
    end
  end

  # profile_imageで指定されたファイルがイメージファイルかどうかを調べる
  def image?
    %w[image/jpg image/jpeg image/gif image/png].include?(profile_image.blob.content_type)
  end
  
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
