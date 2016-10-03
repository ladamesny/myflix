require "spec_helper"

feature "Relationships" do
  scenario "Signed in User can see leaders on 'people I follow' page" do
    larry = Fabricate(:user)
    johnny = Fabricate(:user)
    relationship = Fabricate(:relationship, follower: larry, leader: johnny)
  
    sign_in(larry)

    click_link 'People'

    expect(page.current_path).to eq(people_path)

    within '.people' do
      expect(page).to have_content johnny.queue_items.count
      expect(page).to have_content johnny.followers.count
    end
  end

  scenario "Signed in User can follow a user from the profile page" do
    larry = Fabricate(:user)
    johnny = Fabricate(:user)

    sign_in(larry)

    visit user_path(johnny)
    expect(page).to have_button("Follow")

    click_button "Follow"

    expect(page).to have_button("Following")
  end
end
