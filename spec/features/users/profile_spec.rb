require "spec_helper"

feature "User Profile Page" do
  scenario "visit my profile page" do
    action = Fabricate(:category)
    batman = Fabricate(:video, title: "Batman", category: action)
    superman = Fabricate(:video, title: "Superman", category: action)

    larry = Fabricate(:user)

    review = Fabricate(:review, rating: 3, video: batman, user: larry)
    queue_item = Fabricate(:queue_item, user: larry, video: superman)
 
    sign_in(larry)
    visit user_path(larry)

    expect(page).to have_content "#{larry.full_name}'s video collections (#{larry.video_collection.count})"
    expect(page).to have_content "#{larry.full_name}'s Reviews (#{larry.reviews.count})" 
    expect(page).to_not have_button "Follow"
    within ".queued_videos" do 
      expect(page).to have_content superman.title
    end

    within ".user_reviews" do
      expect(page).to have_content "Rating: #{review.rating}/ 5"
    end
  end
end
