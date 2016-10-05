require "spec_helper"

feature "User following" do
  scenario "user follows and unfollows someone" do
    johnny = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, video: video, user: johnny, rating: 4, body: "Sample Review")

    sign_in

    click_on_video_on_home_page(video)
    expect(page.current_path).to eq(video_path(video))

    within "section.reviews.container" do
      expect(page).to have_link johnny.full_name
    end

    click_link johnny.full_name

    expect(page.current_path).to eq(user_path(johnny))

    click_link "Follow"

    click_link 'People'

    within '.people' do
      expect(page).to have_content johnny.queue_items.count
      expect(page).to have_content johnny.followers.count
    end

    unfollow(johnny)

    within '.people' do
      expect(page).not_to have_content johnny.queue_items.count
      expect(page).not_to have_content johnny.followers.count
    end
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
