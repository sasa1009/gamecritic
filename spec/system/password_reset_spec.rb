require 'rails_helper'

RSpec.describe 'PasswordReset', type: :system, js: true do
  let(:user) {FactoryBot.create(:user)}

  it "displays success message when email was deliverd" do
    visit login_path
    click_link("パスワードを忘れた場合")
    find("#email").set(user.email)
    click_button("メールを送信")
    expect(page).to have_selector(".alert-info")
    expect(page).to have_selector("#email")
    expect(page).to have_selector("#password")
  end

  it "displays alert message when email was not deliverd" do
    visit new_password_reset_path
    find("#email").set("")
    click_button("メールを送信")
    expect(page).to have_selector(".alert-danger")
    expect(page).to have_selector("#email")
    expect(page).to_not have_selector("#password")
  end

  # context "update password" do
  #   before do
  #     visit new_password_reset_path
  #     find("#email").set(user.email)
  #     click_button("メールを送信")
  #     @valid_user = assigns(:user)
  #     debugger
  #   end
  #
  #   it "displays success message when password is updated" do
  #     visit edit_password_reset_path(@valid_user.reset_token, email: @valid_user.email)
  #     expect(page).to have_selector("#password")
  #   end
  # end
end
