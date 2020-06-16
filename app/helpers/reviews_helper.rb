module ReviewsHelper

  def posted?(game)
    game.reviews.find_by(user_id: current_user.id).present?
    game.reviews.to_a.find {|r| r.user_id == current_user.id }.present?
  end

  def user_score(game)
    game.reviews.to_a.find {|r| r.user_id == current_user.id }.score
  end
end
