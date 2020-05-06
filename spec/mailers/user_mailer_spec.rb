require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { UserMailer.account_activation(user) }
  let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i) }.join }

  describe "account_activation" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "renders the headers" do
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "アカウント有効化"
    end

    it "renders the body" do
      expect(mail_body).to match("#{user.name}")
      expect(mail_body).to match(CGI.escape(user.email))
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }
    
    before do
      ActionMailer::Base.deliveries.clear
      user.reset_token = User.new_token
    end

    it "renders the headers" do
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "パスワード再設定"
    end

    it "renders the body" do
      expect(mail_body).to match(CGI.escape(user.email))
    end
  end

end
