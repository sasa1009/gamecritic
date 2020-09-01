require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:lana) { FactoryBot.create(:lana) }

  it "is valid with a name, email" do
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "is invalid without a email" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid when a name too long" do
    user.name = "a" * 51
    expect(user).to_not be_valid
  end

  it "is invalid when a email too long" do
    user.email = "a" * 255 + "@example.com"
    expect(user).to_not be_valid
  end

  describe "email format" do
    let(:valid_addresses) { %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn] }
    let(:invalid_addresses) { %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com] }
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "is valid with correct email" do
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it "is invalid with incorrect email" do
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end

    it "email addresses should be saved as lower-case" do
      user.email = mixed_case_email
      user.save
      expect(mixed_case_email.downcase).to eq user.reload.email
    end

  end

  describe "email uniqueness" do
    let(:duplicate_user) { user.dup }
    it "is invalid when email is not unique" do
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to_not be_valid
    end
  end

  describe "password format" do
    it "is invalid when a password blank" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to_not be_valid
    end

    it "is invalid when a password less than 5 charactars" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to_not be_valid
    end
  end

  # self_introductionに関するテスト
  describe "self introduction format" do
    # self_introductionカラムが1000文字の場合は適正
    it "is valid when self introduction has no more than 1000 characters" do
      user.self_introduction = "あ" * 500
      expect(user).to be_valid
    end
    
    # self_introductionカラムが1000文字以上だとエラーになる
    it "is invalid when self introduction has more than 1000 characters" do
      user.self_introduction = "あ" * 1001
      user.valid?
      expect(user.errors[:self_introduction]).to include("は1000文字以内で入力してください")
    end

  end

  describe "authenticated? should return false for a user with nil digest" do
    # ダイジェストが存在しない場合のauthenticated?のテスト
    it "is invalid without remember_digest" do
      expect(user.authenticated?(:remember, "")).to eq false
    end
  end

  # profile imageに関するテスト
  describe "profile_image" do
    # profile_imageが画像ファイルでない場合エラーになる
    it "is invalid when profile_image is not a image file" do
      lana.profile_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'regex-practice.txt')), filename: 'regex-practice.txt', content_type: 'text')
      expect(lana).to_not be_valid
    end

    it "is invalid when profile_image file size is too large" do
      # profile_imageに添付された画像ファイルが2メガバイト以上の場合エラーになる
      lana.profile_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', '大きい画像.jpg')), filename: '大きい画像.jpg', content_type: 'image/jpeg')
      expect(lana).to_not be_valid
    end
  end

end
