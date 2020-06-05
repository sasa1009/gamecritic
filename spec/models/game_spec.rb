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

    it "is invalid when wrong string in youtube_video_id" do
      sekiro.youtube_video_id = "https://ja.stackoverflow.com/"
      sekiro.valid?
      expect(sekiro.errors[:youtube_video_id]).to include("が正しくありません")
    end

    it "is valid without a youtube_video_id" do
      sekiro.youtube_video_id = nil
      expect(sekiro).to be_valid
    end

    it "is valid with YouTube URL in youtube_video_id" do
      sekiro.youtube_video_id = "https://youtu.be/Zdv28QsMeio"
      expect(sekiro).to be_valid
    end
  end
end
