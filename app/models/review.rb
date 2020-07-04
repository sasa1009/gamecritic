class Review < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: "は既にレビューを投稿しています" }
  validates :title, length: { maximum: 50 } 
  validates :review, length: { maximum: 500 } 
  validate :validate_score
  validate :validate_images

  has_many_attached :images

  #titleとreviewに値が入力されているreviewインスタンスを返す
  scope :review_with_value, -> { where.not(review: "").order(updated_at: "desc") }

  # scoreのバリデーション(1~10の数字以外はエラーになる)
  def validate_score
    regex = /[1-9]/
    if score == nil || score == "" || !score.integer?
      errors.add(:score, "が正しくありません")
    elsif score.to_s.length == 1
      if !score.to_s.match(regex)
        errors.add(:score, "が正しくありません")
      end
    elsif score.to_s.length >= 2
      if score != 10
        errors.add(:score, "が正しくありません")
      end
    end
  end

  # images画像のバリデーション
  def validate_images
    if !!images[2]
      images.purge
      errors.add(:images, "は２つまで指定できます")
    elsif !image_file?
      images.purge
      errors.add(:images, "はイメージファイルを指定して下さい")
    elsif !image_is_less_than_2mb?
      images.purge
      errors.add(:images, "は2メガバイト以下の画像を指定して下さい")
    end
  end

  # imagesで指定されたファイルがイメージファイルかどうかを調べる
  def image_file?
    types = %w[image/jpg image/jpeg image/gif image/png]
    images.all? { |image| types.include?(image.content_type) }
  end

  # imagesで指定されたファイルが2メガバイト以下であるかを調べる
  def image_is_less_than_2mb?
    images.all? { |image| image.byte_size <= 2.megabytes }
  end
end
