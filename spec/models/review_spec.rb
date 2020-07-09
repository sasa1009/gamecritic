require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let(:review1) { FactoryBot.create(:review, user_id: admin.id, game_id: sekiro.id) }
  let(:review2) { FactoryBot.build(:review) }
  let(:review_with_image) { FactoryBot.build(:review_with_image) }

  context "checking validation" do
    before do
      review1
    end
    # user_idとgame_idが一意でないといけない
    it "is invalid when user_id and game_id are not unique" do
      review2.user_id = admin.id
      review2.game_id = sekiro.id
      review2.valid?
      expect(review2.errors[:user_id]).to include("は既にレビューを投稿しています")
      review2.user_id = user.id
      expect(review2).to be_valid
    end
  end

  # titleは50文字以内でないとエラーになる
  it "is invalid when title has more than 50 charactors" do
    review1.title = "a" * 51
    review1.valid?
    expect(review1.errors[:title]).to include("は50文字以内で入力してください")
    review1.title = "a" * 50
    expect(review1).to be_valid
  end

  # reviewは500文字以内でないとエラーになる
  it "is invalid when review has more than 500 charactors" do
    review1.review = "a" * 501
    review1.valid?
    expect(review1.errors[:review]).to include("は500文字以内で入力してください")
    review1.review = "a" * 500
    expect(review1).to be_valid
  end

  # scoreは1~10の整数でないとエラーになる
  it "is invalid when score has other than 1 to 9 integer" do
    review1.score = 0
    review1.valid?
    expect(review1.errors[:score]).to include("が正しくありません")
    review1.score = 11
    review1.valid?
    expect(review1.errors[:score]).to include("が正しくありません")
    review1.score = "あ"
    review1.valid?
    expect(review1.errors[:score]).to include("が正しくありません")
    review1.score = 4
    expect(review1).to be_valid
  end

  # ファイルアップロード機能のテスト
  context "checking image uploading feature" do
    it "returns true true when image is attached" do
      expect(review_with_image.images.attached?).to eq true
    end
  
    it "returns true true when image is attached" do
      review_with_image.images.purge
      expect(review_with_image.images.attached?).to eq false
    end
  end
end
