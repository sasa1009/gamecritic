require 'rails_helper'

RSpec.describe 'UsersShow', type: :system, js: true do
  include ActiveJob::TestHelper
  let(:admin) { FactoryBot.create(:admin, self_introduction: "あ" * 500) }
  before do
    admin.profile_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'ゲラルト編集.jpeg')), filename: 'ゲラルト編集.jpeg', content_type: 'image/jpeg')
    6.times do
      FactoryBot.create(:game, user_id: admin.id)
    end
    id = Game.first.id
    (0..3).each do |i|
      FactoryBot.create(:review, user_id: admin.id, game_id: id + i, score: i + 1)
      FactoryBot.create(:valid_recruitment, user_id: admin.id, game_id: id + i)
    end
    FactoryBot.create(:review_with_image, user_id: admin.id, game_id: id + 4, score: 6)
    FactoryBot.create(:review_with_image, user_id: admin.id, game_id: id + 5, score: 8, review: "これは適正なレビューです<br>" + "あ" * 400)
    FactoryBot.create(:valid_recruitment, user_id: admin.id, game_id: id + 4, description: "あ" * 400)
    Review.last.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'キングダムハーツプレイ２.jpg')), filename: 'キングダムハーツプレイ２.jpg', content_type: 'image/jpeg')
  end
  
  # ユーザープロフィールページの仕様
  describe "specifications of the user profile page" do
    before do
      sign_in_as(admin)
      visit user_path(admin)
    end

    # ユーザーのプロフィール情報の表示
    it "displays user's information" do
      within("div.profile") do
        # プロフィール写真がある
        expect(page).to have_selector("div.image")
        # ユーザー名がある
        expect(find(".user_name")).to have_content(admin.name)
        # 自己紹介文がある
        expect(find(".self_introduction")).to have_content(admin.self_introduction)
        # 自己紹介文のアコーディオン機能がある
        expect(page).to have_selector("a.expand")
        expect(page).to have_selector("div.less_introduction")
        # 「全てを表示」リンクをクリック
        find(".expand").click
        # アコーディオンが展開して自己紹介の全文が表示される
        expect(page).to_not have_selector("div.less_introduction")
      end
      # ユーザーが投稿したレビューとフレンド募集の切り替えタブがある
      within("ul.review_header") do
        expect(page).to have_content("レビュー")
        expect(page).to have_content("フレンド募集")
      end
    end

    # ユーザーが投稿したレビューの表示
    it "displays reviews posted by user in the review tab" do
      within("div.review_wrapper") do
        # レビュータブの画面の中にレビューが表示されている
        expect(page).to have_selector("div.review_alt:nth-child(6)")
        # レビューのなかに
        within("div.review_alt:nth-child(1)") do
          # ゲームのジャケット画像がある
          expect(page).to have_selector("img")
          # 投稿したスコアがある
          expect(page).to have_selector("div.score")
          # ゲームのタイトルがある
          expect(find("p.card-title")).to have_content(Review.last.title)
          # レビュー本文がある
          expect(find("div.text_second_wrapper")).to have_content("これは適正なレビューです")
          # レビューのアコーディオン機能
          expect(find("div.text_second_wrapper")).to have_selector("div.less_text")
          expect(find(".expand")).to have_content("全てを表示")
          find(".expand").click
          expect(find("div.text_second_wrapper")).to_not have_selector("div.less_text")
          expect(find("div.text_second_wrapper")).to have_selector("div.text_first_wrapper")
          expect(find(".expand")).to have_content("折りたたむ")
          find(".expand").click
          expect(find("div.text_second_wrapper")).to have_selector("div.less_text")
          expect(find("div.text_second_wrapper")).to_not have_selector("div.text_first_wrapper")
          # 投稿した画像がある
          expect(page).to have_selector("a.image1")
          expect(page).to have_selector("a.image2")
          page.evaluate_script('$(".fade").removeClass("fade")')
          # 画像をクリックするとモーダルが表示される
          find("a.image1").click
          expect(page).to have_selector("div.modal-body")
          # モーダルの中に画像が表示されている
          expect(find("div.modal-body")).to have_selector("img")
          # ✖︎をクリックするとモーダルが閉じる
          find("button.close1").click
          # ✖︎をクリックするとモーダルが閉じる
          expect(page).to_not have_selector("div.modal-body")
          # レビューを編集するリンクがある
          expect(page).to have_content("レビューを編集する")
          # レビューを削除するリンクがある
          expect(page).to have_content("レビューを削除する")
        end
      end
    end

    it "displays recruitment posted by user in the review tab" do
      first_game_id = Game.first.id
      first_recruitment_id = Recruitment.first.id
      take_full_page_screenshot
      click_link("フレンド募集")
      expect(page).to have_current_path recruitment_user_path(admin)
      within("ul.index_recruitments") do
        # フレンド募集タブの画面の中にフレンド募集が表示されている
        expect(page).to have_selector("div.recruitment:nth-child(5)")
        # フレンド募集投稿の中に
        within("div.recruitment:nth-child(2)") do
          # ゲームのタイトルが表示されている
          expect(find("a.game_title")).to have_content(Game.find(first_game_id + 3).title)
          # フレンド募集のタイトルが表示されている
          expect(find("p.card-title")).to have_content("適正なフレンド募集")
          # フレンド募集の本文が表示されている
          expect(find("p.description")).to have_content(Recruitment.find(first_recruitment_id + 3).description)
          # 投稿を編集するリンクがある
          expect(page).to have_content("投稿を編集する")
          # 投稿を削除するリンクがある
          expect(page).to have_content("投稿を削除する")
        end
        # 本文が長いフレンド募集投稿の中に
        within("div.recruitment:nth-child(1)") do
          # モーダルを表示するためのリンクが表示されている
          expect(find("a.modal_link")).to have_content("全てを表示")
          # リンクをクリックすると
          find("a.modal_link").click
          # モーダルが表示される
          expect(page).to have_selector("div.modal__content")
          # モーダルの中に
          within("div.modal__content") do
            # ゲームのジャケット画像が表示されている
            expect(find("div.jacket_wrapper")).to have_selector("img")
            # ゲームのタイトルが表示されている
            expect(page).to have_selector("a.game_title")
            # 投稿のタイトルが表示されている
            expect(page).to have_selector("p.card-title")
            # 投稿の本文が表示されている
            expect(page).to have_selector("p.description")
            # 「閉じる」をクリックすると
            click_link("閉じる")
          end
          # モーダルが非表示になる
          expect(page).to have_selector("div.modal__content")
        end
      end
    end
  end
end
