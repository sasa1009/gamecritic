require 'rails_helper'

RSpec.describe "Games", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }

  # ゲーム一覧機能
  describe "GET index" do
    # ゲーム一覧画面へのアクセス。
    it "can access to the games index page" do
      get root_path
      expect(response).to have_http_status "200"
    end
  end

  # ゲーム投稿機能
  # ゲーム投稿画面へのアクセス。
  describe "access to the game data posting page" do
    context "without login" do
      # ログインしていないユーザーはログイン画面にリダイレクトされる。
      it "is redirected to the login_page" do
        get new_game_path
        expect(response).to redirect_to login_path
      end
    end

    context "with non admin user" do
      before do
        log_in_as(user)
      end
      # adminでないユーザーがアクセスした場合、ログイン画面にリダイレクトされる。
      it "is redirected to the login_page" do
        get new_game_path
        expect(response).to redirect_to login_path
      end
    end

    context "with admin user" do
      # adminユーザーがアクセスした場合、ゲーム投稿画面が表示される。
      it "can access to the game data posting page" do
        log_in_as(admin)
        get new_game_path
        expect(response).to have_http_status "200"
      end
    end
  end

  # ゲーム投稿
  describe "posting game" do
    before do
      log_in_as(admin)
    end

    context "with invalid data" do
      # タイトル、メーカー、発売日が入力されていない場合ゲームデータが保存されない。
      it "does not add game" do
        expect {
          post games_path, params: { game: { title: "",
                                             developer: "",
                                             release_date: "",
                                             summary: "",
                                             youtube_video_id: "" } }
        }.to_not change(Game, :count)
      end
    end

    context "with valid data" do
      before do
        @image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'ペルソナ５.jpg'), 'image/jpeg')
      end
      # 各項目が入力されている場合ゲームデータが保存される。その場合、ゲーム詳細画面にリダイレクトされる。
      it "adds game and redirected to the game's information page" do
        expect {
          post games_path, params: { game: { title: "Persona 5 Royal",
                                             developer: "Atlus",
                                             release_date: "2020-03-31 00:00:00",
                                             summary: "奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。",
                                             youtube_video_id: "https://youtu.be/o9QjlLdYK5I",
                                             jacket: @image } }
        }.to change(Game, :count).by(1)
        expect(response).to redirect_to game_path(Game.last)
      end
    end
  end

  # ゲーム詳細画面表示機能
  describe "GET show" do
    it "can access to the game's information page" do
      get game_path(sekiro)
      expect(response).to have_http_status "200"
    end
  end

  # ゲーム編集機能
  describe "editing game data" do
    before do
      log_in_as(admin)
    end

    context "with invalid data" do
      # タイトル、メーカーが空文字の場合ゲームデータが更新されない。
      it "can't update game data" do
        patch game_path(sekiro), params: { game: { title: "",
                                           developer: "",
                                           release_date: "",
                                           summary: "奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。",
                                           youtube_video_id: "" } }
        expect(Game.find(sekiro.id).summary).to_not eq ("奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。")
      end
    end

    context "with valid data" do
      # 各項目が入力されている場合ゲームデータが更新される。その場合、ゲーム詳細画面にリダイレクトされる。
      it "update game data and redirected to the game's information page" do
        patch game_path(sekiro), params: { game: { title: sekiro.title,
                                           developer: sekiro.developer,
                                           release_date: sekiro.release_date,
                                           summary: "奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。",
                                           youtube_video_id: sekiro.youtube_video_id } }
        expect(Game.find(sekiro.id).summary).to eq ("奪え、その意志で。ペルソナ5新生(ザ・ロイヤル)―。")
        expect(response).to redirect_to game_path(sekiro)
      end
    end
  end

  # ゲーム削除機能
  describe "deleting game" do
    before do
      log_in_as(admin)
    end
    # adminユーザーがアクセスした場合、ゲームデータが削除される。
    it "deletes the game data" do
      expect {
        delete game_path(sekiro)
      }.to change(Game, :count).by(-1)
      expect(response).to redirect_to root_path
    end
  end
end
