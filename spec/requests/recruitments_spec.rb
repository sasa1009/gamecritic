require 'rails_helper'

RSpec.describe "Recruitments", type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let(:valid_recruitment) { FactoryBot.create(:valid_recruitment, game_id: sekiro.id, user_id: admin.id) }
  let(:valid_recruitment2) { FactoryBot.create(:valid_recruitment, game_id: sekiro.id, user_id: user.id) }

  describe "posting recruitment" do
    context "without login" do
      # ログインしていない状態でnew_recruitment_pathにアクセスするとログイン画面にリダイレクトされる
      it "is redirected to the login_path" do
        get new_recruitment_path
        expect(response).to redirect_to login_path
      end
    end

    context "with login" do
      before do
        log_in_as(admin)
      end

      # ログインしている状態でnew_recruiment_pathにアクセスするとアクセスに成功する
      it "can access to the new_recruitment_path" do
        get new_recruitment_path
        expect(response).to have_http_status "200"
      end

      # 不正な値を送信した場合はフレンド募集が作成されない
      it "does not create recruitment with invalid parameters" do
        expect {
          post recruitments_path, params: { game_id: nil,
                                            recruitment: {
                                              title: nil,
                                              description: nil} }
        }.to_not change(Recruitment, :count)
        # 既にフレンド募集を作成している場合はフレンド募集が作成されない
        valid_recruitment
        expect {
          post recruitments_path, params: { game_id: sekiro.id,
                                            recruitment: {
                                              title: "hoge",
                                              description: "fuga"} }
        }.to_not change(Recruitment, :count)
      end

      # ログインしていて、フレンド募集を未投稿で、本文を入力している場合に場合にフレンド募集を投稿することができる
      it "creates recruiment with valid parameters" do
        expect {
          post recruitments_path, params: { game_id: sekiro.id,
                                            recruitment: {
                                              title: "hoge",
                                              description: "fuga"} }
        }.to change(Recruitment, :count).by (1)
        # フレンド募集を投稿するとゲーム詳細ページのフレンド募集タブにリダイレクトされる
        expect(response).to redirect_to recruitments_game_path(sekiro)
      end
    end
  end

  describe "editing recruitment" do
    context "without login" do
      it "can not access to the recruitment editing page when user does not login" do
        valid_recruitment
        get edit_recruitment_path(valid_recruitment)
        expect(response).to redirect_to login_path
      end
    end

    context "with login" do
      before do
        log_in_as(admin)
        valid_recruitment
        valid_recruitment2
      end

      # 本文が空の状態だとフレンド募集の投稿を編集できない
      it "cannot update recruitment with invalid parameters" do
        description = valid_recruitment.description
        patch recruitment_path(valid_recruitment), params: { game_id: sekiro.id,
                                                             recruitment: {
                                                               title: "hogehoge",
                                                               description: ""}}
        expect(Recruitment.find(valid_recruitment.id).description).to eq description 
      end

      # 他人のフレンド募集の投稿は削除できない
      it "cannot update other users recruitment" do
        description = valid_recruitment2.description
        patch recruitment_path(valid_recruitment2), params: { game_id: sekiro.id,
                                                              recruitment: {
                                                                title: "hogehoge",
                                                                description: "fugafuga"}}
        expect(Recruitment.find(valid_recruitment2.id).description).to include(description)
      end

      # 現在ログインしているユーザーとフレンド募集投稿者が同じ場合にフレンド募集の投稿を編集できる
      it "can update recruitment" do
        patch recruitment_path(valid_recruitment), params: { game_id: sekiro.id,
                                                             recruitment: {
                                                               title: "hogehoge",
                                                               description: "fugafuga"}}
        expect(Recruitment.find(valid_recruitment.id).description).to include("fugafuga")
      end

      context "via user profile page" do
        # session["previous_page"]にユーザープロフィールページのハッシュを代入
        let(:rspec_session) { { "previous_page" => { "controller" => "users", "action" => "recruitment", "id" => "#{admin.id}" } } }
        # ユーザー詳細ページにある「投稿を編集する」リンクからレビューを編集するとゲーム詳細ページにリダイレクトされる
        it "is redirected to the recruitment tab in the user profile page" do
          rspec_session
          # レビューの投稿を編集するとユーザープロフィール画面のレビュータブにリダイレクトされる
          patch recruitment_path(valid_recruitment), params: { game_id: sekiro.id,
                                                                recruitment: {
                                                                  title: "hogehoge",
                                                                  description: "fugafuga"}}
          expect(response).to redirect_to recruitment_user_path(valid_recruitment.user_id)
        end
      end

      context "via game's detail page" do
        # session["previous_page"]にゲーム詳細ページのハッシュを代入
        let(:rspec_session) { { "previous_page" => { "controller" => "games", "action" => "recruitments", "id" => "#{valid_recruitment.game_id}" } } }
        # ユーザー詳細ページにある「投稿を編集する」リンクからレビューを編集するとゲーム詳細ページにリダイレクトされる
        it "is redirected to the recruitment tab in the user profile page" do
          rspec_session
          # レビューの投稿を編集するとユーザープロフィール画面のレビュータブにリダイレクトされる
          patch recruitment_path(valid_recruitment), params: { game_id: sekiro.id,
                                                                recruitment: {
                                                                  title: "hogehoge",
                                                                  description: "fugafuga"}}
          expect(response).to redirect_to recruitments_game_path(valid_recruitment.game_id)
        end
      end
    end
  end

  describe "deleting recruitment" do
    before do
      log_in_as(admin)
      valid_recruitment
      valid_recruitment2
    end
    
    # 現在ログインしているユーザーとフレンド募集投稿者が違う場合はフレンド募集を削除できない
    it "cannot delete other users recruitment" do
      expect {
        delete recruitment_path(valid_recruitment2)
      }.to_not change(Recruitment, :count)
    end

    # 現在ログインしているユーザーとフレンド募集投稿者が同じである場合にフレンド募集を削除できる
    it "can delete when current user's id and recruitment's user_id are same" do
      expect {
        delete recruitment_path(valid_recruitment)
      }.to change(Recruitment, :count).by(-1)
      # フレンド募集を削除するとゲーム詳細ページのフレンド募集タブにリダイレクトされる
      expect(response).to redirect_to recruitments_game_path(sekiro)
    end
  end
end
