module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, remember_me: true)
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: remember_me} }
  end

  def sign_in_as(user)
    visit login_path
    find("#email").set(user.email)
    find("#password").set(user.password)
    click_button "ログイン"
  end

  def take_screenshot
    page.save_screenshot("tmp/screenshots/screenshot-#{DateTime.now}.png")
  end
end
