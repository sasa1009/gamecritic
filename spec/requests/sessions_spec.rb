require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "login" do

    context "access to the login page" do
      it "responds successfully" do
        get login_path
        expect(response).to have_http_status "200"
      end
    end

    let!(:user) { FactoryBot.create(:user) }

    context "with invalid information" do
      it "is not redirected to profile page" do
        post login_path, params: { session: { email: "",
                                           password: "" } }
        expect(response).to_not redirect_to "/users/#{user.id}"
      end
    end

    context "with valid information" do
      before "valid login" do
        post login_path, params: { session: { email: user.email,
                                           password: "password" } }
      end

      it "is redirected to profile page" do
        expect(response).to redirect_to "/users/#{user.id}"
        expect(is_logged_in?).to be_truthy
      end
    end

    context "with remembering" do
      it "contain remember_token in cookies" do
        log_in_as(user, remember_me: "1")
        expect(response.cookies['remember_token']).to_not eq nil
      end
    end

    context "without remembering" do
      it "doesn't contain remember_token in cookies" do
        log_in_as(user, remember_me: nil)
        expect(response.cookies['remember_token']).to eq nil
      end
    end
  end

  describe "logout" do
    let(:user) { FactoryBot.create(:user) }

    before do
      # ログインする
      log_in_as(user)
    end

    it "is redirected to login page" do
      delete logout_path
      expect(response).to redirect_to login_path
      expect(is_logged_in?).to be_falsey
    end

    context "when other tab has already logouted" do
      it "is redirected to login page" do
        # 1番目のウィンドウでログアウトする
        delete logout_path
        expect(response).to redirect_to login_path
        expect(session[:user_id]).to eq nil
        # 2番目のウィンドウでログアウトする
        delete logout_path
        expect(response).to redirect_to login_path
        expect(session[:user_id]).to eq nil
      end
    end
  end
end
