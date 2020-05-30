class Game < ApplicationRecord
  belongs_to :user
  validates :title,  presence: true
  validates :developer,  presence: true
  validates :release_date,  presence: true

  has_one_attached :jacket

  # YouTubeのurlからvideo_idを抜き出す
  def self.get_video_id(youtube_url)
    url = youtube_url
    url = url.last(11)
    return url
  end

end
