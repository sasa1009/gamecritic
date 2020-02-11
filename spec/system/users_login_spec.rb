require 'rails_helper'

RSpec.describe 'UsersLogin', type: :system, js: true do

  it "login with invalid information" do
    visit login_path
    fill_in "メールアドレス", with: ""
    fill_in "パスワード", with: ""
    click_button "ログイン"
    expect(page).to have_selector(".alert-danger")
    visit login_path
    expect(page).to_not have_selector(".alert-danger")
  end

end
