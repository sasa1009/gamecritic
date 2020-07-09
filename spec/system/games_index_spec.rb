require 'rails_helper'

RSpec.describe 'GamesIndex', type: :system, js: true do
  include ActiveJob::TestHelper
  let!(:admin) { FactoryBot.create(:admin) }
  before do
    FactoryBot.create(:kingdom_hearts, user_id: admin.id)
    FactoryBot.create(:user)
    9.times do
      FactoryBot.create(:game, user_id: admin.id)
      FactoryBot.create(:user)
    end
    id = Game.first.id
    user_id = User.first.id
    (0..9).each do |i|
      game = Game.find(id + i)
      if i == 0
        for x in 1..10 do
          user = User.find(user_id + x)
          x % 2 == 0 ? score = 7 : score = 10
          game.reviews.create(user_id: user.id,
                              score: score,
                              review: "hogehoge" )
        end
        game.reviews.create(user_id: admin.id,
                            score: 6,
                            review: "hogehoge" )
      elsif i == 1
        for x in 1..10 do
          user = User.find(user_id + x.to_i)
          x % 2 == 0 ? score = 4 : score = 7
          game.reviews.create(user_id: user.id,
                              score: score,
                              review: "hogehoge" )
        end
        game.reviews.create(user_id: admin.id,
                            score: 3,
                            review: "hogehoge" )
      else  
        for x in 1..10 do
          user = User.find(user_id + x.to_i)
          game.reviews.create(user_id: user.id,
                              score: rand(1..4),
                              review: "hogehoge" )
        end
      end
    end
    sign_in_as(admin)
  end

  it "displays all of its item" do
    visit root_path
    # ページネーションのボタンが表示されている
    expect(page).to have_selector(".pagination")
    within("div.index_game_info:nth-child(1)") do
      # ジャケット画像が表示されている
      expect(page).to have_selector(".index_jacket")
      # 平均スコアが表示されている
      expect(find("div.average_score")).to have_content("8.3")
      expect(find("div.index_score")).to have_selector(".green")
      # 自分の投稿したスコアが表示されている
      # スコアによってスコアを囲むバッジの色が変わっている
      expect(find("div.user_score")).to have_content("6")
      expect(find("div.index_score")).to have_selector(".yellow")
      # ゲームのタイトルが表示されている
      expect(page).to have_selector(".index_game_title")
      # ゲームの発売日が表示されている
      expect(page).to have_content("2020-08-01")
      # ゲームのメーカーが表示されている
      expect(page).to have_content("スクウェア・エニックス")
      # ゲームの概要が表示されている
      expect(page).to have_selector(".less_summary")
      # 概要が長い場合には「全てを表示」が表示されている
      expect(find(".summary_second_wrapper")).to have_selector(".expand")
      #「全てを表示」を押すと概要が全て表示されて「全てを表示」が「折りたたむ」に切り替わる
      expect(find(".expand")).to have_content("全てを表示")
      find(".expand").click
      expect(page).to have_selector(".summary_first_wrapper")
      expect(find(".expand")).to have_content("折りたたむ")
      # 「折りたたむ」を押すと概要が省略されて「全てを表示」に切り替わる
      find(".expand").click
      expect(page).to have_selector(".less_summary")
      expect(find(".expand")).to have_content("全てを表示")
    end
    # ページ内に７つのゲームソフトが表示されている
    expect(page).to have_selector("div.index_game_info:nth-child(6)")
    expect(page).to_not have_selector("div.index_game_info:nth-child(7)")
  end
  
  it "doesn't displays user score when current user hasn't posted review" do
    visit root_path
    within("div.index_game_info:nth-child(3)") do
      # ユーザーがレビューを投稿していないゲームには「あなたのスコア」が表示されない
      expect(page).to_not have_selector(".user_score_wrapper")
    end
  end
  
end
