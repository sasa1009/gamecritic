require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "アカウント有効化"
    end

    it "renders the body" do
      # expect(mail.body.encoded).to match("#{user.name} さん、こんにちは。")
      expect(mail.body).to match(CGI.escape(user.email))
    end
  end


end
