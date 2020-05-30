require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:sekiro) { FactoryBot.create(:sekiro, user_id: admin.id) }

  context "checking validation" do
    it "is invalid without a title" do
      sekiro.title = nil
      sekiro.valid?
      expect(sekiro.errors[:title]).to include("を入力してください")
    end

    it "is invalid without a developer" do
      sekiro.developer = nil
      sekiro.valid?
      expect(sekiro.errors[:developer]).to include("を入力してください")
    end

    it "is invalid without a release_date" do
      sekiro.release_date = nil
      sekiro.valid?
      expect(sekiro.errors[:release_date]).to include("を入力してください")
    end
  end

  context "checking class method" do
    # 与えられた文字列の最後の１１文字を返す
    specify "get_video_id returns last 11 charactars in given string" do
      expect(Game.get_video_id("https://youtu.be/rXMX4YJ7Lks")).to eq "rXMX4YJ7Lks"
    end
  end
end
