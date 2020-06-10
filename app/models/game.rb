class Game < ApplicationRecord
  belongs_to :user
  validates :title,  presence: true
  validates :developer,  presence: true
  validates :release_date,  presence: true
  validates :youtube_video_id, length: { is: 11, message: "が正しくありません" }, format: { with: /[0-9A-Za-z_-]{11}/, message: "が正しくありません" }, if: :youtube_video_id_present?
  validate :validate_jacket
  
  has_one_attached :jacket

  # 入力されたYouTubeのアドレスからvideo idを取得する
  before_validation :get_youtube_video_id
  
  def get_youtube_video_id
    regex1 = /https:\/\/www.youtube.com\/watch\?v=([0-9A-Za-z_-]{11})[&=0-9A-Za-z_-]*/
    regex2 = /https:\/\/youtu.be\/([0-9A-Za-z_-]{11})/
    if self.youtube_video_id == nil
      # Do nothing
    elsif self.youtube_video_id.match(regex1)
      self.youtube_video_id = self.youtube_video_id.match(regex1)[1]
    elsif self.youtube_video_id.match(regex2)
      self.youtube_video_id = self.youtube_video_id.match(regex2)[1]
    end
  end

  # youtube_video_idに値があるか調べる
  def youtube_video_id_present?
    self.youtube_video_id.present?
  end

  # jacket画像のバリデーション
  def validate_jacket
    if !jacket.attached?
      errors.add(:jacket, "を指定して下さい")
    else
      if jacket.blob.byte_size > 5.megabytes
        jacket.purge
        errors.add(:jacket, "は5メガバイト以下の画像を指定して下さい")
      elsif !image?
        jacket.purge
        errors.add(:jacket, "はイメージファイルを指定して下さい")
      end
    end
  end

  # jacketで指定されたファイルがイメージファイルかどうかを調べる
  def image?
    %w[image/jpg image/jpeg image/gif image/png].include?(jacket.blob.content_type)
  end
end
