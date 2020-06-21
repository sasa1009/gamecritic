require 'rails_helper'

RSpec.describe 'ReviewsEditAndDelete', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let!(:game) { FactoryBot.create(:game, user_id: admin.id) }
  before do
    # レビューを複数個作成
    for i in 1 .. 5 do
      user_i = FactoryBot.create(:user)
      FactoryBot.create(:review, score: i, user_id: user_i.id, game_id: sekiro.id)
    end
  end
  let!(:review1) { FactoryBot.create(:review, user_id: admin.id, game_id: sekiro.id) }

  # レビューの編集
  describe "editing review" do
    # ログインしていないユーザー
    context "without login" do
      it "can't access to the review editing page" do
        visit game_path(sekiro)
        # games/show.html.erbに「レビューを編集する」リンクが表示されない
        within(".index_reviews") do
          expect(page).to_not have_content("レビューを編集する")
          expect(page).to_not have_content("レビューを削除する")
        end
      end
    end

    # ログインしているユーザー
    context "with login" do
      before do
        sign_in_as(admin)
      end

      it "can edit and delete review" do
        visit game_path(sekiro)
        # games/show.html.erbに「レビューを編集する」リンクが表示される
        within(".card:nth-child(1)") do
          expect(find(".card-body")).to have_content("レビューを編集する")
          expect(find(".card-body")).to have_content("レビューを削除する")
        end
        # 「レビューを編集する」リンクをクリックするとレビュー編集画面が表示される
        find_link("レビューを編集する").click
        select(value = "7", from: "review[score]") 
        find("#title").set("編集後")
        find("#review").set("テスト")
        click_button("編集")
        # 各項目を入力して「レビューを編集」ボタンをクリックするとレビューが更新されてgames/show.html.erbにリダイレクトされる
        expect(page).to have_current_path(game_path(sekiro))
        expect(page).to have_content("レビューが更新されました")
        within(".card:nth-child(1)") do
          expect(find(".score")).to have_content("7")
          expect(find(".card-title")).to have_content("編集後")
          expect(find(".card-text")).to have_content("テスト")
        end
        visit root_path
        within(".index_game_info:nth-child(2)") do
          expect(find(".average_score")).to have_content("3.7")
          expect(find(".user_score")).to have_content("7")
        end
        # レビューの削除
        # games/show.html.erbにアクセス
        visit game_path(sekiro)
        accept_confirm do
          find_link("レビューを削除する").click
        end
        # レビューが削除されてgames/show.html.erbにリダイレクトされる
        expect(page).to have_current_path(game_path(sekiro))
        expect(page).to have_content("レビューが削除されました")
        within(".card:nth-child(1)") do
          expect(find(".score")).to_not have_content("7")
          expect(find(".card-title")).to_not have_content("編集後")
          expect(find(".card-text")).to_not have_content("テスト")
        end
        # 画面に「レビューを書く」ボタンが表示されている
        within(".review_header") do
          expect(find(".new_review_2")).to have_content("レビューを書く")
        end
        visit root_path
        within(".index_game_info:nth-child(2)") do
          expect(find(".average_score")).to have_content("3")
          expect(page).to_not have_selector(".user_score")
        end
      end
    end
  end
end



