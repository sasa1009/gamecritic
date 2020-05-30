require 'rails_helper'

RSpec.describe 'GamesPost', type: :system, js: true do
  include ActiveJob::TestHelper

  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }

  describe "access to the Game Post page" do
    context "with non admin user" do
      # アドミンユーザー以外がログインしている場合はゲーム投稿画面へのリンクが表示されない。
      it "can't access to the Game Post page" do
        sign_in_as(user)
        click_link("Menu")
        expect(page).to_not have_selector("#game_post")
      end
    end

    context "with non admin user" do
      # アドミンユーザーがログインしている場合はゲーム投稿画面へのリンクが表示される。
      it "can access to the Game Post page" do
        sign_in_as(admin)
        click_link("Menu")
        expect(page).to have_selector("#game_post")
      end
    end
  end

  describe "posting game data" do
    before do
      sign_in_as(admin)
      visit new_game_path
    end

    context "with invalid information" do
      # 不適切な情報を入力した場合ゲームデータが作成されない。
      it "does not create game data" do
        find("#title").set("")
        find("#developer").set("")
        find("#game_release_date_1i").set("")
        find("#game_release_date_2i").set("")
        find("#game_release_date_3i").set("")
        find("#summary").set("")
        click_button("投稿")
        expect(page).to have_selector(".alert-danger")
        expect(page).to have_selector("#title")
      end
    end

    context "with valid information" do
      # 適切な情報を入力した場合ゲームデータが作成される。
      it "creates game data and redirect to the game's information page" do
        find("#title").set("Persona 5 Royal")
        find("#developer").set("Atlus")
        find("#game_release_date_1i").set("2020")
        find("#game_release_date_2i").set("3")
        find("#game_release_date_3i").set("31")
        find("#summary").set("奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。")
        click_button("投稿")
        expect(page).to have_current_path game_path(Game.last)
        expect(page).to have_selector(".alert-info")
      end
    end
  end
end
