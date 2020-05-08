require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let!(:archer) { FactoryBot.create(:archer) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:michael) { FactoryBot.create(:michael) }
  let(:user_params) { { name: '',
                        email: '',
                        password: '',
                        password_confirmation: '' }

  }
  let(:valid_user_params) { { name: 'Edited User',
                        email: 'edited@gmail.com',
                        password: 'password',
                        password_confirmation: 'password' }

  }

  describe "Get index" do
    context "without login" do
      it "is redirected to the login_page" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end

    context "with login" do
      before do
        log_in_as(user)
      end

      it "can access to the index page" do
        get users_path
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "sign up" do
    context "access to the sign up page" do
      it "responds successfully" do
        get signup_path
        expect(response).to have_http_status "200"
      end
    end

    context "with invalid information" do
      it "does not add a user" do
        expect {
          post signup_path, params: { user: user_params }
        }.to_not change(User, :count)
      end
    end

    context "with valid information" do
      it "add auser" do
        expect {
          post signup_path, params: { user: valid_user_params }
        }.to change(User, :count).by(1)
      end
      it "is redirected to games index page" do
        post signup_path, params: { user: valid_user_params }
        expect(response).to redirect_to games_path
        expect(is_logged_in?).to eq false
      end
      specify "account activation feature" do
        post signup_path, params: { user: valid_user_params }
        user = assigns(:user)
        expect(user.activated?).to eq false
        # 有効化していない状態でログインしてみる
        log_in_as(user)
        expect(is_logged_in?).to be false
        # 有効化トークンが不正な場合
        get edit_account_activation_path("invalid token", email: user.email)
        expect(is_logged_in?).to be false
        # トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(is_logged_in?).to be false
        # 有効化トークンが正しい場合
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(is_logged_in?).to be true
        expect(user.reload.activated?).to eq true
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "GET show" do
    context "access to the profile page without activated" do
      it "is redirected to games index page" do
        get user_path(michael)
        expect(response).to redirect_to games_path
      end
    end

    context "access to the profile page" do
      it "responds successfully" do
        get user_path(user)
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "edit" do
    before do
      log_in_as(user)
    end

    context "access to the setting page" do
      it "responds successfully" do
        get edit_user_path(user)
        expect(response).to have_http_status "200"
      end
    end

    context "with invalid information" do
      it "is not redirected to profile page" do
        patch user_path(user), params: { user: user_params }
        expect(response).to_not redirect_to users_path(user)
      end
    end

    context "with valid information" do
      it "is redirected to profile page" do
        patch user_path(user), params: { user: valid_user_params }
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "edit with invalid status" do
    shared_examples 'access to the settiong page is redirected to login page' do
      it {
        get edit_user_path(user)
        is_expected.to redirect_to login_path
      }
    end
    shared_examples 'patch request to the update action is redirected to login page' do
      it {
        patch user_path(user), params: { user: valid_user_params }
        is_expected.to redirect_to login_path
      }
    end
    context "without login" do
      it_behaves_like 'access to the settiong page is redirected to login page'
      it_behaves_like 'patch request to the update action is redirected to login page'
    end

    context "with wrong user" do
      before do
        log_in_as(archer)
      end
      it_behaves_like 'access to the settiong page is redirected to login page'
      it_behaves_like 'patch request to the update action is redirected to login page'
    end
  end

  describe "admin attribute" do
    before do
      log_in_as(archer)
    end
    it "should not be edited via the web" do
      expect(archer.admin).to eq false
      expect {
        patch user_path(archer), params: { user: { password: "password",
                                                   password_confirmation: "password",
                                                   admin: true } }
      }.to_not change { User.find_by(name: "Sterling Archer").admin }
    end
  end

  describe "delete" do
    shared_examples 'is redirected to login page' do
      it {
        expect {
          delete user_path(archer)
        }.to_not change { User.count }
        expect(response).to redirect_to login_path
      }
    end

    context "without login" do
      it_behaves_like 'is redirected to login page'
    end

    context "with non admin user" do
      before do
        log_in_as(user)
      end
      it_behaves_like 'is redirected to login page'
    end

    context "with admin user" do
      it "deletes user or redirect to users page when user is already deleted" do
        log_in_as(admin)
        expect {
          delete user_path(archer)
        }.to change { User.count }.by(-1)
        expect(response).to redirect_to users_path
        expect {
          delete user_path(archer)
        }.to_not change { User.count }
        expect(response).to redirect_to users_path
      end
    end
  end
end
