require 'rails_helper'

RSpec.describe 'ReviewsPost', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:kingdom_hearts) { FactoryBot.create(:kingdom_hearts, user_id: admin.id) }
  let!(:game) { FactoryBot.create(:game, user_id: admin.id) }
  let!(:review1) { FactoryBot.create(:review, user_id: user.id, game_id: kingdom_hearts.id) }

  # レビューの投稿
  describe "posting review" do
    # ログインしていないユーザー
    context "without login" do
      it "is redirected to the login_path" do
        # games/show.html.erbにアクセス
        visit game_path(kingdom_hearts)
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
          FactoryBot.create(:review, score: i, user_id: user_i.id, game_id: kingdom_hearts.id)
        end
      end

      it "can post review" do
        # games/show.html.erbにアクセス
        # 「レビューを書く」ボタンが表示されている
        visit game_path(kingdom_hearts)
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
        expect(page).to have_current_path new_review_path(game_id: kingdom_hearts.id)
        select(value = "5", from: "review[score]") 
        find("#title").set("hogehoge")
        find("#review").set("限定版を購入しました。
          無印版をクリア＆トロコン済み。
          全体的には、ストーリーの追加に加えて前作の様々な要素を調整した完全版という印象。
          無印版との主な違いは以下の通りです。
          ・新しい仲間の追加（登場や関連イベント自体は序盤から）
          ・ゲーム後半からの新展開（新学期）
          ・新しいアルカナのコープが追加
          ・正義コープのイベントのリニューアル
          ・各コープイベント後のアフター会話が追加（選択次第でCPを入手できる）
          ・一部のセリフに音声追加
          ・各種新規アイテムの追加
          ・仲間のペルソナのスキル追加や習得レベルの変更、最終進化ペルソナ（と各キャラ専用スキル）の追加")
        find(".file1").set(Rails.root.join('spec', 'fixtures', 'files', 'キングダムハーツプレイ１.jpg'), filename: 'キングダムハーツプレイ１.jpg')
        find(".file2").set(Rails.root.join('spec', 'fixtures', 'files', 'キングダムハーツプレイ２.jpg'), filename: 'キングダムハーツプレイ２.jpg')
        click_button("投稿")
        # 項目を入力して投稿ボタンを押すとレビューが投稿される
        expect(page).to have_current_path game_path(kingdom_hearts)
        expect(page).to have_content("レビューが投稿されました")
        # あなたのスコアの所に自分が評価したスコアが表示されている
        expect(page).to have_selector(".user_score")
        # 評価したスコアに応じてスコアを囲むバッジの色が変化している
        expect(page).to have_selector(".yellow")
        expect(find("div.user_score")).to have_content("5")
        # 「レビューを書く」ボタンの表示がなくなっている
        expect(page).to_not have_selector("a#new_review_btn")
        # 自分が投稿したレビューがgames/show.html.erbに表示されている
        within("div.card:nth-child(1)") do
          expect(page).to have_content("無印版をクリア＆トロコン済み。")
          expect(page).to have_content("レビューを編集する")
          #「全てを表示」を押すと概要が全て表示されて「全てを表示」が「折りたたむ」に切り替わる
          expect(find(".expand")).to have_content("全てを表示")
          find(".expand").click
          expect(page).to have_selector(".text_first_wrapper")
          expect(find(".expand")).to have_content("折りたたむ")
          # 「折りたたむ」を押すと概要が省略されて「全てを表示」に切り替わる
          find(".expand").click
          expect(page).to have_selector(".less_text")
          expect(find(".expand")).to have_content("全てを表示")
          # 添付した画像が表示されている
          expect(page).to have_selector(".image1")
          expect(page).to have_selector(".image2")
        end
        # モーダルがある
        expect(page).to have_selector(".modal-body", visible: false)
        expect(page).to have_selector("img", visible: false)
        within("div.game_info") do
          # games/index.html.erbのゲーム詳細情報に自分が投稿したスコアが表示されている
          expect(find("div.user_score")).to have_content("5")
          # レビューの平均値に応じてスコアを囲むバッジが色分けされている
          expect(find("div.score")).to have_selector(".yellow")
          # games/show.html.erbとgames/index.html.erbにレビューの平均値が表示されている
          # レビューの平均値に応じてスコアを囲むバッジが色分けされている
          expect(find("div.average_score")).to have_content("3.6")
          expect(find("div.score")).to have_selector(".red")
        end
        # レビューに表示されている投稿者名をクリックすると投稿者のプロフィールページに移動する
        within("div.card:nth-child(1)") do
          find("a.user_name").click
        end
        expect(page).to have_current_path user_path(admin)
        # views/games/index.html.erbにゲームの平均スコアと自分が投稿したスコアが標示される
        visit root_path
        within(".index_game_info:nth-child(1)") do
          expect(find(".average_score")).to have_content("3.6")
          expect(find(".user_score")).to have_content("5")
        end
      end
    end
  end
end
