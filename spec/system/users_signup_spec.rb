require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system, js: true do

  it "signup with invalid information" do
    visit signup_path
    find("#name").set("")
    find("#email").set("")
    find("#password").set("")
    find("#password_confirmation").set("")
    click_button "登録"
    expect(page).to have_selector("#error_explanation")
    expect(page).to have_link("Signup", href: signup_path)
    visit signup_path
    expect(page).to_not have_selector("#error_explanation")
  end

  it "signup with valid information" do
    visit signup_path
    find("#name").set("Example User")
    find("#email").set("example@gmail.com")
    find("#password").set("password")
    find("#password_confirmation").set("password")
    click_button "登録"
    expect(page).to have_current_path "/users/#{User.last.id}"
    expect(page).to have_content(User.last.name)
    expect(page).to have_selector(".alert-success")
    expect(page).to have_selector(".gravatar")
    expect(page).to have_link("Menu")
  end

end
