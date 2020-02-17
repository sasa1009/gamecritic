# require 'rails_helper'
#
# RSpec.describe SessionsController, type: :controller do
#
#   describe "login" do
#
#     context "access to the login page" do
#       it "responds successfully" do
#         get :new
#         expect(response).to be_successful
#         expect(response).to have_http_status "200"
#       end
#     end
#
#     let!(:user) { FactoryBot.create(:user) }
#
#     context "with invalid information" do
#       it "is  not redirected to profile page" do
#         post :create, params: { session: { email: "",
#                                            password: "" } }
#         expect(response).to_not redirect_to "/users/#{user.id}"
#       end
#     end
#
#     context "with valid information" do
#       before "valid login" do
#         post :create, params: { session: { email: user.email,
#                                            password: "password" } }
#       end
#
#       it "is redirected to profile page" do
#         expect(response).to redirect_to "/users/#{user.id}"
#       end
#
#       it "logged_in returns true" do
#         expect(logged_in?).to be true
#       end
#     end
#   end
#
#   describe "logout" do
#     it "is redirected to login page" do
#       delete :destroy
#       expect(response).to redirect_to login_path
#     end
#   end
#
# end
