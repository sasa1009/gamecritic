require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system, js: true do
  before do
    @archer = FactoryBot.create(:archer)
    @admin = FactoryBot.create(:admin)
    @users = FactoryBot.create_list(:user, 30)
    @lana = FactoryBot.create(:lana)
  end

  context "as admin user" do
    it "includes pagination and delete link in the index page" do
      sign_in_as(@admin)
      visit users_path
      expect(page).to have_content(@lana.name)
      expect(page).to_not have_content(@archer.name)
      expect(page).to have_selector("ul.pagination")
      expect(page).to have_selector(".delete")
      accept_confirm do
        find_link("delete", href: "/users/#{@lana.id}").click
      end
      expect(page).to_not have_content(@lana.name)
      expect(page).to have_current_path(users_path)
      within("div#upside") do
        click_link("最後")
      end
      expect(page).to have_content(@archer.name)
    end
  end

  context "as non-admin user" do
    it "does not includes delete link" do
      sign_in_as(@archer)
      visit users_path
      expect(page).to_not have_selector(".delete")
    end
  end

end
