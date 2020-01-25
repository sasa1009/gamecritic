require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create(name: "Example User", email: "exampleuser@gmail.com",
                           password: "foobar", password_confirmation: "foobar") }

  it "is valid with a name, email" do
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a email" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
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


end
