require "spec_helper"

feature "User Signs In" do
  scenario "with valid credentials" do
    larry = Fabricate(:user)
    sign_in(larry)
    expect(page).to have_content("Welcome #{larry.full_name}, you've successfully logged into myFlix!")
  end
end