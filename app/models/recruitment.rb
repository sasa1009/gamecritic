class Recruitment < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: "は既にフレンド募集を投稿しています" }
  validates :title, length: { maximum: 50 } 
  validates :description, presence: true, length: { maximum: 500 } 

  #titleとreviewに値が入力されているreviewインスタンスを返す
  scope :sort_recruitment, -> { order(updated_at: "desc") }

end
