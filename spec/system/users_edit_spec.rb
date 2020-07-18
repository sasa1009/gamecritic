require 'rails_helper'

RSpec.describe 'UsersEdit', type: :system, js: true do

  let!(:user) { FactoryBot.create(:user) }

  it "edit with invalid information" do
    sign_in_as(user)
    visit edit_user_path(user)
    find("#name").set("")
    find("#email").set("")
    find("#password").set("")
    find("#password_confirmation").set("")
    click_button "更新"
    expect(page).to have_selector("#error_explanation")
    expect(page).to have_selector(".form-control")
    visit signup_path
    expect(page).to_not have_selector("#error_explanation")
  end

  it "edit with valid information and friendly forwarding" do
    visit edit_user_path(user)
    expect(page).to have_current_path login_path
    find("#email").set(user.email)
    find("#password").set(user.password)
    click_button "ログイン"
    expect(page).to have_current_path edit_user_path(user)
    find("#name").set("Edited User")
    find("#email").set("edited@gmail.com")
    find("#password").set("")
    find("#password_confirmation").set("")
    find("#file_field").set(Rails.root.join('spec', 'fixtures', 'files', 'ゲラルト編集.jpeg'), filename: 'ゲラルト編集.jpeg')
    click_button "更新"
    expect(page).to_not have_selector("#error_explanation")
    expect(page).to have_selector(".alert-success")
    expect(page).to have_current_path user_path(user)
    expect(page).to have_content("Edited User")
    expect(page).to have_selector("img.profile_image")
  end

end
