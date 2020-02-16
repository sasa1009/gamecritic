require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "sign up" do
    context "access to the sign up page" do
      it "responds successfully" do
        get signup_path
        expect(response).to have_http_status "200"
      end
    end

    context "with invalid information" do
      let(:user_params) { { name: '',
                            email: 'user@invalid',
                            password: '',
                            password_confirmation: '' }

      }
      it "does not add a user" do
        expect {
          post signup_path, params: { user: user_params }
        }.to_not change(User, :count)
      end
    end

    context "with valid information" do
      let(:user) { FactoryBot.attributes_for(:user) }
      it "add auser" do
        expect {
          post signup_path, params: { user: user }
        }.to change(User, :count).by(1)
      end
      it "is redirected to profile page" do
        post signup_path, params: { user: user }
        expect(response).to redirect_to "/users/#{User.last.id}"
        expect(is_logged_in?).to be_truthy
      end
    end
  end

  describe "GET show" do
    let!(:user) { FactoryBot.create(:user) }
    context "access to the profile page" do
      it "responds successfully" do
        get user_path(user)
        expect(response).to have_http_status "200"
      end
    end
  end

end
