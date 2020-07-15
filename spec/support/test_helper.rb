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

  def take_full_page_screenshot
    width  = Capybara.page.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
    height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
  
    window = Capybara.current_session.driver.browser.manage.window
    window.resize_to(width+100, height+100)
  
    page.save_screenshot("tmp/screenshots/screenshot-#{DateTime.now}.png")
  end
end
