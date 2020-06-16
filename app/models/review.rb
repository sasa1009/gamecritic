class Review < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user_id, uniqueness: { scope: :game_id, message: "は既にレビューを投稿しています" }
  validates :title, length: { maximum: 50 } 
  validates :review, length: { maximum: 500 } 
  validate :validate_score

  private

    #titleとreviewに値が入力されているreviewインスタンスを返す
    scope :review_with_value, -> { where.not(title: "", review: "").order(created_at: "desc") }

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

end
