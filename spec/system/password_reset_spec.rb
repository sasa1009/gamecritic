require 'rails_helper'

RSpec.describe 'PasswordReset', type: :system, js: true do
  let(:user) {FactoryBot.create(:user)}
  let(:reset_user) {FactoryBot.create(:reset)}

  context "delivering email" do
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
  end

  context "update password" do
    before do
      visit edit_password_reset_path(reset_user.reset_token, email: reset_user.email)
    end

    it "displays success message when password was updated" do
      find("#password").set("reset_password")
      find("#password_confirmation").set("reset_password")
      click_button("パスワード更新")
      expect(page).to have_selector(".alert-success")
      expect(page).to have_content("パスワードが更新されました。")
      expect(page).to have_current_path user_path(reset_user)
    end

    it "displays alert message when password was not updated" do
      find("#password").set("reset_password")
      find("#password_confirmation").set("hoge_password")
      click_button("パスワード更新")
      expect(page).to have_selector("#error_explanation")
    end

    it "displays alert message when reset_sent_at was expired" do
      reset_user.update_attribute(:reset_sent_at, 3.hours.ago)
      find("#password").set("reset_password")
      find("#password_confirmation").set("reset_password")
      click_button("パスワード更新")
      expect(page).to have_selector(".alert-danger")
    end

  end
end
