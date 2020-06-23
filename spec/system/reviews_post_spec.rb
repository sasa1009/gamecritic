require 'rails_helper'

RSpec.describe 'ReviewsPost', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let!(:game) { FactoryBot.create(:game, user_id: admin.id) }
  let!(:review1) { FactoryBot.create(:review, user_id: user.id, game_id: sekiro.id) }

  # レビューの投稿
  describe "posting review" do
    # ログインしていないユーザー
    context "without login" do
      it "is redirected to the login_path" do
        # games/show.html.erbにアクセス
        visit game_path(sekiro)
        # 「レビューを書く」ボタンが表示されている
        expect(page).to have_selector("#new_review_btn")
        # 「レビューを書く」ボタンを押すとログイン画面にリダイレクトされる
        within("div.score_inner_bottom") do
          find("#new_review_btn").click
        end
        expect(page).to have_current_path login_path
      end
    end

    # ログインしているユーザー
    context "with login" do
      before do
        sign_in_as(admin)
        # レビューを複数個作成
        for i in 1 .. 5 do
          user_i = FactoryBot.create(:user)
          FactoryBot.create(:review, score: i, user_id: user_i.id, game_id: sekiro.id)
        end
      end

      it "can post review" do
        # games/show.html.erbにアクセス
        # 「レビューを書く」ボタンが表示されている
        visit game_path(sekiro)
        expect(page).to have_selector(".average_score")
        expect(page).to have_selector("#new_review_btn")
        expect(page).to have_selector(".no_score")
        expect(page).to have_selector(".index_reviews")
        # 自分が投稿したレビュー以外は編集できない
        expect(find("ul.index_reviews")).to_not have_content("レビューを編集する")
        # 「レビューを書く」ボタンを押すとレビュー投稿画面が表示される
        within("div.score_inner_bottom") do
          find("#new_review_btn").click
        end
        expect(page).to have_current_path new_review_path(game_id: sekiro.id)
        select(value = "5", from: "review[score]") 
        find("#title").set("hogehoge")
        find("#review").set("fugafuga")
        click_button("投稿")
        # 項目を入力して投稿ボタンを押すとレビューが投稿される
        expect(page).to have_current_path game_path(sekiro)
        expect(page).to have_content("レビューが投稿されました")
        # あなたのスコアの所に自分が評価した点数が表示されている
        expect(page).to have_selector(".user_score")
        expect(find("div.user_score")).to have_content("5")
        # 「レビューを書く」ボタンの表示がなくなっている
        expect(page).to_not have_selector("a#new_review_btn")
        # 自分が投稿したレビューがgames/show.html.erbに表示されている
        expect(find("ul.index_reviews")).to have_content("fugafuga")
        expect(find("ul.index_reviews")).to have_content("レビューを編集する")
        # games/show.html.erbとgames/index.html.erbにレビューの平均値が表示されている
        expect(find("div.average_score")).to have_content("3.6")
        # views/games/index.html.erbにゲームの平均スコアと自分が投稿したスコアが標示される
        visit root_path
        within(".index_game_info:nth-child(2)") do
          expect(find(".average_score")).to have_content("3.6")
          expect(find(".user_score")).to have_content("5")
        end
      end
    end
  end
end
