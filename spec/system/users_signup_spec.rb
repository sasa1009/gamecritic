require 'rails_helper'

RSpec.describe 'UsersSignup', type: :system, js: true do
  include ActiveJob::TestHelper

  it "signup with invalid information" do
    visit signup_path
    find("#name").set("")
    find("#email").set("")
    find("#password").set("")
    find("#password_confirmation").set("")
    click_button "登録"
    expect(page).to have_selector("#error_explanation")
    expect(page).to have_link("Signup", href: signup_path)
    visit signup_path
    expect(page).to_not have_selector("#error_explanation")
  end

  context "signup with valid information" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "be a success and sends confirmation email" do
      perform_enqueued_jobs do
        visit signup_path
        find("#name").set("Example User")
        find("#email").set("example@gmail.com")
        find("#password").set("password")
        find("#password_confirmation").set("password")
        click_button "登録"
        expect(page).to have_current_path root_path
        expect(page).to have_selector(".alert-info")

        expect(ActionMailer::Base.deliveries.size).to eq(1)
        mail = ActionMailer::Base.deliveries.last

        aggregate_failures do
          expect(mail.to).to eq ["example@gmail.com"]
          expect(mail.subject).to eq "アカウント有効化"
        end
      end
    end
  end
end
