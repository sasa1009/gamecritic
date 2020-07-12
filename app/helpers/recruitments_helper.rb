module RecruitmentsHelper

  def recruitment_posted?(game)
    game.recruitments.find {|r| r.user_id == current_user.id }.present?
  end
  
end
