require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system do

  it "signup with invalid information" do
    visit new_user_path

    fill_in :name, with: ""
    fill_in :email, with: "user@invalid"
    fill_in :password, with: "foo"
    fill_in :password_confirmation, with: "bar"
    click_button "登録"

    expect(page).to have_content "ユーザ名を入力してください"
  end


end
