require 'rails_helper'

RSpec.describe 'UsersLogin', type: :system, js: true do

  it "login with invalid information" do
    visit login_path
    find("#email").set("")
    find("#password").set("")
    click_button "ログイン"
    expect(page).to have_selector(".alert-danger")
    expect(page).to have_link("Login", href: login_path)
    expect(page).to have_link("Signup", href: signup_path)
    visit login_path
    expect(page).to_not have_selector(".alert-danger")
  end

  it "login with valid information followed by logout" do
    user = FactoryBot.create(:user)
    visit login_path
    find("#email").set(user.email)
    find("#password").set("password")
    click_button "ログイン"
    expect(page).to have_current_path "/users/#{user.id}"
    expect(page).to have_content("#{user.name}")
    expect(page).to_not have_link("Login", href: login_path)
    expect(page).to_not have_link("Signup", href: signup_path)
    expect(page).to_not have_selector(".alert-danger")
    click_link("Menu")
    expect(page).to have_link("Profile", href: "/users/#{user.id}")
    expect(page).to have_link("Logout", href: logout_path)
    click_link("Logout", href: logout_path)
    expect(page).to have_current_path login_path
    expect(page).to_not have_link("Menu")
    expect(page).to have_link("Login", href: login_path)
  end

end
