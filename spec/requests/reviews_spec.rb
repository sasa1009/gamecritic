require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let!(:game) { FactoryBot.create(:game, user_id: admin.id) }
  let!(:review1) { FactoryBot.create(:review, user_id: admin.id, game_id: sekiro.id) }

  describe "posting review" do
    context "without login" do
      # ログインしていない状態でnew_review_pathにアクセスするとログイン画面にリダイレクトされる
      it "is redirected to the login_path" do
        get new_review_path
        expect(response).to redirect_to login_path
      end
    end

    context "with login" do
      before do
        log_in_as(admin)
      end

      # ログインしている状態でnew_review_pathにアクセスするとアクセスに成功する
      it "can access to the new_review_path" do
        get new_review_path
        expect(response).to have_http_status "200"
      end

      # 不正な値を送信した場合はレビューが作成されない
      # 既にレビューを作成している場合はレビューが作成されない
      it "does not create review with invalid parameters" do
        expect {
          post reviews_path, params: { game_id: nil,
                                       review: {
                                         score: nil,
                                         title: nil,
                                         review: nil} }
        }.to_not change(Review, :count)
        expect {
          post reviews_path, params: { game_id: sekiro.id,
                                       review: {
                                         score: 8,
                                         title: "hoge",
                                         review: "fuga"} }
        }.to_not change(Review, :count)
      end

      # 適正な値を送信するとレビューが作成される
      it "creates review with valid parameters" do
        expect {
          post reviews_path, params: { game_id: game.id,
                                       review: {
                                        score: 5,
                                        title: "hoge",
                                        review: "fuga" } }
        }.to change(Review, :count).by(1)
      end
    end
  end

  describe "editing review" do
    # ログインしているユーザーとレビューの投稿者が異なる場合、レビューを更新できない
    it "can not update review which posted by other user" do
      log_in_as(user)
      patch review_path(review1), params: { review: {
                                              score: 5,
                                              title: "hoge",
                                              review: "更新後のレビューです"},
                                            game_id: review1.game_id,
                                            id: review1.id }
      expect(Review.find(review1.id).review).to include("これは適正なレビューです")
      expect(response).to redirect_to game_path(Game.find(review1.game_id))
    end

    # ログインしているユーザーとレビューの投稿者が同じで、適正な値を送信するとレビューが更新される
    it "can update own review" do
      log_in_as(admin)
      patch review_path(review1), params: { review: {
                                              score: 5,
                                              title: "hoge",
                                              review: "更新後のレビューです"},
                                            game_id: review1.game_id,
                                            id: review1.id }
      expect(Review.find(review1.id).review).to include("更新後のレビューです")
      expect(response).to redirect_to game_path(Game.find(review1.game_id))
    end
  end

  describe "deleting review" do
    # レビューを削除しようとしているユーザーとレビューの作者が異なる場合レビューを削除できない
    it "can not delete review which posted by other user" do
      log_in_as(user)
      expect {
        delete review_path(review1)
      }.to_not change(Review, :count)
      expect(response).to redirect_to game_path(Game.find(review1.game_id))
    end

    # レビューを削除しようとしているユーザーとレビューの作者が同じ場合レビューを削除できる
    it "can not delete review which posted by other user" do
      log_in_as(admin)
      expect {
        delete review_path(review1)
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to game_path(Game.find(review1.game_id))
    end
  end
end
