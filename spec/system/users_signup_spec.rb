require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system, js: true do

  it "signup with invalid information" do
    visit signup_path

    expect {
      fill_in "ユーザ名", with: ""
      fill_in "メールアドレス", with: "user@invalid"
      fill_in "パスワード", with: "foo"
      fill_in "パスワード（確認用）", with: "bar"
      click_button "登録"

      expect(page).to have_content("ユーザ名を入力してください")
      expect(page).to have_content("メールアドレスは不正な値です")
      expect(page).to have_content("6文字以上")
      expect(page).to have_content("入力が一致しません")
      expect(page).to have_selector("#error_explanation")
      expect(page).to have_selector(".field_with_errors")
    }.to_not change(User, :count)
  end

  it "signup with valid information" do
    visit signup_path

    expect {
      fill_in "ユーザ名", with: "Example User"
      fill_in "メールアドレス", with: "user@exapmle.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_button "登録"

      expect(page).to have_content(User.last.name)
      expect(page).to have_selector(".alert-success")
      expect(page).to have_selector(".gravatar")
    }.to change(User, :count).by(1)
  end

end
