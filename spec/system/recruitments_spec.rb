require 'rails_helper'

RSpec.describe 'Recruitments', type: :system, js: true do
  include ActiveJob::TestHelper

  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:lana) { FactoryBot.create(:lana) }
  let(:kingdom_hearts) { FactoryBot.create(:kingdom_hearts, user_id: admin.id) }
  let(:game) { FactoryBot.create(:game, user_id: admin.id) }

  describe "posting recruitment" do
    before do
      kingdom_hearts
      (1..10).each do |i|
        FactoryBot.create(:recruitment, game_id: kingdom_hearts.id)
      end
      FactoryBot.create(:valid_recruitment, game_id: kingdom_hearts.id, user_id: lana.id, description: "あ"*500)
    end

    # フレンド募集に関する各種アイテムがゲーム詳細ページの「フレンド募集」タブに表示されている
    it "displays items related with recruitment in the 'フレンド募集'tab" do
      # ゲーム詳細ページにアクセス
      visit game_path(kingdom_hearts)
      # 「フレンド募集」をクリックするとフレンド募集タブにアクセスできる
      within("ul.review_header") do
        click_link("フレンド募集")
      end
      expect(page).to have_current_path recruitments_game_path(kingdom_hearts)
      # フレンド募集タブ内に
      within("div.recruitment_wrapper") do
        # ページネーションが表示されている
        expect(page).to have_selector("div.review_pagenation_top")
        expect(page).to have_selector("div.review_pagenation_bottom")
        # 「フレンド募集を書く」ボタンが表示されている
        expect(page).to have_selector("a.new_recruitment_button")
        # フレンド募集投稿の中に
        within("div.card:nth-child(1)") do
          # 投稿者のプロフィール画像が表示されている
          expect(page).to have_selector("img.profile_image")
          # 投稿者名が表示されている
          expect(page).to have_selector("a.user_name")
          # タイトルが表示されている
          expect(find("p.card-title")).to have_content("適正なフレンド募集")
          # 本文が表示されている
          expect(find("p.description")).to have_content("あ"*500)
          # 「全てを表示」リンクが表示されている（本文が長い場合）
          # リンクをクリックするとモーダルが標示される
          find("a.modal_link").click
        end
        #　モーダルの中に
        within("div.modal__content") do
          # 投稿者のプロフィール画像が表示されている
          expect(page).to have_selector("img.profile_image")
          # 本文が表示されている
          expect(find("p.description")).to have_content("あ"*500)
          # 「閉じる」リンクをクリックすると
          find("a.modal-close-0").click
        end
        # モーダルが消える
        expect(page).to_not have_selector("div.modal__content")
      end
    end

    it "is posting procedure" do
      visit recruitments_game_path(kingdom_hearts)
      # 「フレンド募集を書く」ボタンをクリック
      find("a.new_recruitment_button").click
      # ログインページが表示される
      expect(page).to have_current_path login_path
      find("#email").set(admin.email)
      find("#password").set(admin.password)
      click_button("ログイン")
      # ログインするとレビュー投稿画面が表示される
      expect(page).to have_current_path new_recruitment_path(game_id: kingdom_hearts.id)
      # 本文を入力せずに投稿ボタンを押すと「本文を入力してください」というメッセージが表示される
      click_button("投稿")
      expect(page).to have_content("本文を入力してください")
      # 本文を入力して投稿ボタンを押すとゲーム詳細ページのフレンド募集タブにリダイレクトされる
      find("#title").set("システムスペックのテスト（タイトル）")
      find("#description").set("システムスペックのテスト（本文）")
      click_button("投稿")
      expect(page).to have_current_path recruitments_game_path(kingdom_hearts)
      expect(page).to have_content("フレンド募集が投稿されました")
      # フレンド募集タブ内に自分の投稿がある
      within("div.recruitment_wrapper") do
        within("div.card:nth-child(1)") do
          # adminはプロフィール画像を登録していないので替りのイメージが表示される
          expect(page).to have_selector("img.no_image")
          # 投稿者名が表示されている
          expect(page).to have_content(admin.name)
          # 投稿したタイトルが表示されている
          expect(find("p.card-title")).to have_content("システムスペックのテスト（タイトル）")
          expect(find("p.description")).to have_content("システムスペックのテスト（本文）")
          # 自分の募集には「全てを表示」リンクがない（本文が短い場合）
          expect(page).to_not have_selector("a.modal_link")
        end
      end
    end
  end

  describe "editing and deleting recruitment" do
    before do
      kingdom_hearts
      FactoryBot.create(:valid_recruitment, game_id: kingdom_hearts.id, user_id: admin.id, title: "システムスペックのテスト（タイトル）", description: "システムスペックのテスト（本文）")
      (1..4).each do |i|
        FactoryBot.create(:recruitment, game_id: kingdom_hearts.id)
      end
      FactoryBot.create(:valid_recruitment, game_id: kingdom_hearts.id, user_id: lana.id, description: "あ"*500)
      sign_in_as(admin)
    end

    it "is procedure of editing and deleting " do
      visit recruitments_game_path(kingdom_hearts)
      # 自分の投稿に「投稿を編集する」リンクがある
      within("div.card:nth-child(6)") do
        click_link("投稿を編集する")
      end
      # 「投稿を編集する」リンクをクリックすると投稿編集画面に移動する
      expect(page).to have_current_path edit_recruitment_path(Recruitment.first)
      # 投稿を編集して編集ボタンを押すとゲーム詳細ページのフレンド募集タブにリダイレクトされる
      find("#title").set("フレンド募集の編集（タイトル）")
      find("#description").set("フレンド募集の編集（本文）")
      click_button("編集")
      expect(page).to have_current_path recruitments_game_path(kingdom_hearts)
      expect(page).to have_content("投稿が更新されました")
      # 編集したことによって自分の投稿が投稿一覧の先頭に配置されている
      # 編集の内容が投稿に反映されている
      within("div.card:nth-child(1)") do
        expect(find("p.card-title")).to have_content("フレンド募集の編集（タイトル）")
        expect(find("p.description")).to have_content("フレンド募集の編集（本文）")
        # 「投稿を削除する」リンクをクリックするとゲーム詳細ページのフレンド募集タブにリダイレクトされる
        accept_confirm do
          click_link("投稿を削除する")
        end
      end
      expect(page).to have_current_path recruitments_game_path(kingdom_hearts)
      expect(page).to have_content("投稿が削除されました")
      # 自分の投稿が削除されている
      within("div.recruitment_wrapper") do
        expect(page).to_not have_content(admin.name)
      end
    end

    # ユーザープロフィールページからのフレンド募集投稿の編集と削除
    it "is redirected to the user profile page when edit and delete recruitment via user profile page" do
      visit recruitment_user_path(admin)
      within("div.card:nth-child(1)") do
        click_link("投稿を編集する")
      end
      # 投稿を編集して編集ボタンを押すとユーザープロフィールページのフレンド募集タブにリダイレクトされる
      find("#title").set("フレンド募集の編集（タイトル）")
      find("#description").set("フレンド募集の編集（本文）")
      click_button("編集")
      expect(page).to have_current_path recruitment_user_path(admin)
      within("div.card:nth-child(1)") do
        accept_confirm do
          click_link("投稿を削除する")
        end
      end
      # 「投稿を削除する」リンクをクリックするとフレンド募集投稿が削除されてユーザープロフィールページのフレンド募集タブにリダイレクトされる
      expect(page).to have_current_path recruitment_user_path(admin)
    end
  end
end
