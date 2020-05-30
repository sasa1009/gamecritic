require 'rails_helper'

RSpec.describe 'GamesEditAndDelete', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }

  # ゲーム編集画面へのアクセス
  describe "access to the game data edit page" do
    context "with non admin user" do
      before  do
        sign_in_as(user)
      end

      # 管理者でない人はゲーム詳細画面にゲーム編集画面へのリンクが表示されない
      it "can't access to the game data edit page" do
        visit game_path(sekiro)
        expect(page).to_not have_selector("#edit")
        expect(page).to_not have_selector("#delete")
      end
    end

    context "with admin user" do
      before  do
        sign_in_as(admin)
      end
      # 管理者はゲーム詳細画面からゲーム編集画面にアクセス出来る
      it "can access to the game data edit page" do
        visit game_path(sekiro)
        expect(page).to have_selector("#edit")
        expect(page).to have_selector("#delete")
        find_link("ゲームデータを編集", id: "edit").click
        expect(page).to have_current_path edit_game_path(sekiro)
      end
    end
  end

  # ゲーム編集
  describe "editing game data" do
    before do
      sign_in_as(admin)
      visit edit_game_path(sekiro)
    end

    # ジャケット画像とYouTube URLを入力するとゲーム詳細画面に追加される
    # ジャケット画像をアップロードした場合、game.jacket.attached?がtrueになる。
    it "edits the game data and redirect to the game's information page" do
      find("#file_field").set(Rails.root.join('spec', 'fixtures', 'files', 'SEKIRO.jpg'), filename: 'SEKIRO.jpg')
      find("#youtube_url").set("https://youtu.be/rXMX4YJ7Lks")
      find_button("編集").click
      expect(page).to have_current_path game_path(sekiro)
      expect(page).to have_selector(".alert-success")
      expect(page).to have_selector(".jacket")
      expect(page).to have_selector(".youtube")
      expect(sekiro.jacket.attached?).to eq true
    end
  end

  # ゲーム削除
  describe "deleting game data" do
    before do
      sign_in_as(admin)
      visit game_path(sekiro)
    end

    # ゲーム削除リンクをクリックするとゲームが削除されてゲーム一覧画面にリダイレクトされる。
    it "deletes game data and redirect to root path" do
      accept_confirm do
        find_link(id: "delete").click
      end
      expect(page).to have_current_path root_path
      expect(page).to have_selector(".alert-success")
    end
  end
end
