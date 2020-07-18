require 'rails_helper'

RSpec.describe Recruitment, type: :model do
  let(:admin) { FactoryBot.create(:admin) }
  let(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }
  let(:recruitment) { FactoryBot.create(:recruitment, game_id: sekiro.id) }
  let(:recruitment2) { FactoryBot.create(:recruitment, game_id: sekiro.id) }
  
  context "checking validation" do
    # 各項目が入力されているフレンド募集はエラーにならない
    it "is valid when all items are inputed" do
      expect(recruitment).to be_valid
    end

    # user_idが入力されていないとエラーになる
    it "is invalid when user_id is nil" do
      recruitment.user_id = nil
      expect(recruitment.valid?).to eq false
      expect(recruitment.errors[:user_id]).to include("を入力してください")
    end 

    # game_idが入力されていないとエラーになる
    it "is invalid when game_id is nil" do
      recruitment.game_id = nil
      expect(recruitment.valid?).to eq false
      expect(recruitment.errors[:game_id]).to include("を入力してください")
    end 

    # game_idとuser_idの組み合わせはユニークでないといけない
    it "is invalid when user_id and game_id are not unique" do
      recruitment
      recruitment2.user_id = User.second.id
      expect(recruitment2.valid?).to eq false
      expect(recruitment2.errors[:user_id]).to include("は既にフレンド募集を投稿しています")
    end

    # titleは50文字以内でないといけない
    it "is invalid when title have more than 51 charactors" do
      recruitment.title = "a"*51
      expect(recruitment.valid?).to eq false
      expect(recruitment.errors[:title]).to include("は50文字以内で入力してください")
    end

    # descriptionが記入されていないとエラーになる
    it "is invalid when description is not inputed" do
      recruitment.description = ""
      expect(recruitment.valid?).to eq false
      expect(recruitment.errors[:description]).to include("を入力してください")
    end

    # descriptionは500文字以内でないといけない
    it "is invalid when title have more than 501 charactors" do
      recruitment.description = "a"*501
      expect(recruitment.valid?).to eq false
      expect(recruitment.errors[:description]).to include("は500文字以内で入力してください")
    end
  end
end
