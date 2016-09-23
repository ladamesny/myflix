require "spec_helper"

feature "queue item management" do
  scenario "user adds video to queue" do
    action = Fabricate(:category)
    batman = Fabricate(:video, title: "Batman", category: action)
    spiderman = Fabricate(:video, title: "Spiderman", category: action)
    superman = Fabricate(:video, title: "Superman", category: action)

    sign_in

    add_video_to_queue batman
    expect_video_to_be_in_queue(batman)

    visit video_path(batman)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue spiderman
    add_video_to_queue superman

    set_queue_item_position batman, 2
    set_queue_item_position spiderman, 3
    set_queue_item_position superman, 1

    update_queue

    expect_queue_item_position superman, 1
    expect_queue_item_position batman, 2
    expect_queue_item_position spiderman, 3
  end
end

def update_queue
  click_button "Update Instant Queue"
end

def expect_link_not_to_be_seen(link_text)
  expect(page).not_to have_link(link_text)
end

def expect_video_to_be_in_queue video
  expect(page).to have_content(video.title)
end

def set_queue_item_position video, position
  find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").set(position)
end

def expect_queue_item_position video, position
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
end

def add_video_to_queue video
  visit root_path
  find("a[data-video-id='#{video.id}']").click
  click_link('+ My Queue')
end
