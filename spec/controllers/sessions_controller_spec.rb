require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "login" do
    context "invalid information" do

    end

    context "valid information" do

      let!(:user) { FactoryBot.create(:michael) }

      it "is redirected to profile page" do
        post :create, params: { session: { email: user.email,
                                           password: "password" } }
        expect(response).to redirect_to "/users/#{user.id}"
      end

    end

  end

end
