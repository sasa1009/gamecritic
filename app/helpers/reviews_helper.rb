module ReviewsHelper

  def posted?(game)
    game.reviews.find {|r| r.user_id == current_user.id }.present?
  end

  def user_score(game)
    game.reviews.find {|r| r.user_id == current_user.id }.score
  end
end
