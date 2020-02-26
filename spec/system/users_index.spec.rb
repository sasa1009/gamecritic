require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system, js: true do
  let!(:archer) { FactoryBot.create(:archer) }
  FactoryBot.create_list(:user, 30)

  it "includes pagination in the index page" do
    sign_in_as(archer)
    visit users_path
    expect(page).to have_content("User 1")
    expect(page).to have_content("User 25")
    expect(page).to have_selector("ul.pagination")
    expect(page).to_not have_content("User 26")
  end

end
