require 'rails_helper'

RSpec.describe 'UsersDelete', type: :system, js: true do
  include ActiveJob::TestHelper

  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }

  context "by admin user" do
    before do
      sign_in_as(admin)
    end

    it "does not display link to the account delete page in the admin user's setting page" do
      # ユーザー編集ページにアクセス
      visit edit_user_path(admin)
      # adminユーザーのユーザー編集ページにはアカウント削除ページへのリンクが表示されない
      expect(page).to_not have_selector(".delete_account")
    end
  end

  context "by non admin user" do
    before do
      sign_in_as(user)
    end

    it "can access to the account delete page" do
      # ユーザー編集ページにアクセス
      visit edit_user_path(user)
      expect(page).to have_selector(".delete_account")
      # ユーザー編集ページ内のリンクからアカウント削除ページにアクセス
      find_link("アカウントの削除はこちらから").click
      expect(page).to have_current_path delete_account_user_path(user)
    end

    it "can't delete account when checkbox isn't checked" do
      visit delete_account_user_path(user)
      # チェックボックスにチェックせずに削除をクリックすると、再度アカウント削除ページとチェックを促すフラッシュが表示される
      find(".btn").click
      expect(page).to have_content "同意してアカウントを削除する"
      expect(page).to have_selector(".alert-danger")
    end

    it "can delete account when checkbox is checked" do
      visit delete_account_user_path(user)
      # チェックボックスにチェックして削除をクリックすると、ゲーム一覧ページとアカウントが削除された事を知らせる旨のフラッシュが表示される
      expect {
        find("#user_delete_account").click
        find(".btn").click
      }.to change(User, :count).by(-1)
      expect(page).to have_current_path root_path
      expect(page).to have_selector(".alert-success")
    end
  end
end
