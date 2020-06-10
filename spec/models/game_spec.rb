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

    it "is valid with YouTube URL in youtube_video_id" do
      sekiro.youtube_video_id = "https://youtu.be/Zdv28QsMeio"
      expect(sekiro).to be_valid
    end

    it "is valid with blank in youtube_video_id" do
      sekiro.youtube_video_id = ""
      expect(sekiro).to be_valid
    end

    it "is invalid when jacket is not attached" do
      sekiro.jacket.purge
      expect(sekiro).to_not be_valid
    end

    it "is invalid when jacket is not a image file" do
      sekiro.jacket.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'regex-practice.txt')), filename: 'regex-practice.txt', content_type: 'text')
      expect(sekiro).to_not be_valid
    end

    it "is invalid when jacket file size is too large" do
      sekiro.jacket.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', '大きい画像.jpg')), filename: '大きい画像.jpg', content_type: 'image/jpeg')
      expect(sekiro).to_not be_valid
    end
  end
end
