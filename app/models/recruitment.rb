class Recruitment < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: "は既にレビューを投稿しています" }
  validates :title, length: { maximum: 50 } 
  validates :description, length: { maximum: 500 } 
end
