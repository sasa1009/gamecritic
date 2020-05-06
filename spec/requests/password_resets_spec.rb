require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) {FactoryBot.create(:user)}

  describe "Password reset" do
    it "accesses to the email form" do
      get new_password_reset_path
      expect(response).to have_http_status "200"
    end

    context "sending email" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it "does not deliver email when email is invalid" do
        post password_resets_path, params: { password_reset:
                                            { email: "" } }
        expect(ActionMailer::Base.deliveries.size).to eq(0)
        expect(response).to_not redirect_to login_path
      end

      it "delivers email and redirect to login path when email is valid" do
        post password_resets_path, params: { password_reset:
                                            { email: user.email } }
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(response).to redirect_to login_path
      end
    end

    context "update password" do
      before do
        post password_resets_path, params: { password_reset:
                                            { email: user.email } }
        @valid_user = assigns(:user)
      end

      it "can't access to the password form when email is invalid" do
        # メールアドレスが無効
        get edit_password_reset_path(@valid_user.reset_token, email: "")
        expect(response).to redirect_to login_path
        # 無効なユーザー
        @valid_user.toggle!(:activated)
        get edit_password_reset_path(@valid_user.reset_token, email: user.email)
        expect(response).to redirect_to login_path
        @valid_user.toggle!(:activated)
        # メールアドレスが有効で、トークンが無効
        get edit_password_reset_path("wrong token", email: @valid_user.email)
        expect(response).to redirect_to login_path
      end

      it "accesses to the password form when email is valid" do
        get edit_password_reset_path(@valid_user.reset_token, email: @valid_user.email)
        expect(response).to have_http_status "200"
      end

      it "doesn't update password when password is invalid" do
        # 無効なパスワードとパスワード確認
        patch password_reset_path(@valid_user.reset_token),
              params: { email: @valid_user.email,
                        user: { password: "foobar",
                                password_confirmation: "hogehoge"} }
        expect(@valid_user.password_digest).to eq user.password_digest
        expect(response).to_not redirect_to user_path(@valid_user)
        # パスワードが空
        patch password_reset_path(@valid_user.reset_token),
          params: { email: @valid_user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
        expect(@valid_user.password_digest).to eq user.password_digest
        expect(response).to_not redirect_to user_path(@valid_user)
        # reset_tokenの有効期限切れ
        @valid_user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@valid_user.reset_token),
          params: { email: @valid_user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
        expect(@valid_user.password_digest).to eq user.password_digest
        expect(response).to_not redirect_to user_path(@valid_user)
      end

      it "updates password when password is valid" do
        patch password_reset_path(@valid_user.reset_token),
          params: { email: @valid_user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
        @updated_user = assigns(:user)
        expect(@updated_user.authenticate("foobaz")).to be_truthy
        expect(@updated_user.reset_digest).to eq nil
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to user_path(@updated_user)
      end
    end
  end
end
