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

    it "is invalid without a youtube_video_id" do
      sekiro.youtube_video_id = ""
      sekiro.valid?
      expect(sekiro.errors[:youtube_video_id]).to include("が正しくありません")
    end
  end
end
