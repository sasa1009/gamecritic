class Game < ApplicationRecord
  belongs_to :user
  validates :title,  presence: true
  validates :developer,  presence: true
  validates :release_date,  presence: true
  validates :youtube_video_id, format: { with: /[0-9A-Za-z_-]{11}/,
  message: "が正しくありません" }
  
  has_one_attached :jacket

  # Viewから送信されてきたYouTube URLの末尾11文字を抜き出してyoutube_video_idカラムに格納する
  before_validation do
    regex1 = /https:\/\/www.youtube.com\/watch\?v=([0-9A-Za-z_-]{11})[&=0-9A-Za-z_-]*/
    regex2 = /https:\/\/youtu.be\/([0-9A-Za-z_-]{11})/
    if self.youtube_video_id.match(regex1)
      self.youtube_video_id = self.youtube_video_id.match(regex1)[1]
    elsif self.youtube_video_id.match(regex2)
      self.youtube_video_id = self.youtube_video_id.match(regex2)[1]
    end
  end
end
