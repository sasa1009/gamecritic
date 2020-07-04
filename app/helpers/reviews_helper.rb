module ReviewsHelper

  def posted?(game)
    game.reviews.find {|r| r.user_id == current_user.id }.present?
  end

  def user_score(game)
    game.reviews.find {|r| r.user_id == current_user.id }.score
  end

  def review_color(score)
    if score <= 3.9
      return "red"
    elsif score >= 4 && score <= 6.9
      return "yellow"
    else
      return "green"
    end
  end
end
