require "spec_helper"

describe Category do
  it { should have_many(:videos) }
end

describe "#recent_videos" do
  it "returns the vidoes in the reverse chronilogical order by created_at" do
    action = Category.create(name: "Action")
    batman = Video.create(title: "Batman", description: "First Batman", category: action, created_at: 1.day.ago)
    batman_returns = Video.create(title: "Batman Returns", description: "Best Batman", category: action)
    expect(action.recent_videos).to eq([batman_returns, batman])
  end

  it "returns all the videos if there are less than 6 videos" do
    action = Category.create(name: "Action")
    batman = Video.create(title: "Batman", description: "First Batman", category: action, created_at: 1.day.ago)
    batman_returns = Video.create(title: "Batman Returns", description: "Best Batman", category: action)
    expect(action.recent_videos.count).to eq(2)
  end

  it "returns 6 videos if there are more than 6 videos" do
    action = Category.create(name: "Action")
    7.times { Video.create(title: "Batman Returns", description: "Best Batman", category: action) }
    expect(action.recent_videos.count).to eq(6)
  end

  it "returns the most recent 6 videos" do
    action = Category.create(name: "Action")
    6.times { Video.create(title: "Batman Returns", description: "Best Batman", category: action) }
    tonights_show = Video.create(title: "Tonight's show", description: "talk show", category: action, created_at: 1.day.ago)
    expect(action.recent_videos).not_to include(tonights_show)
  end

  it "returns an empty array if the category does not have any videos" do
    action = Category.create(name: "Action")
    expect(action.recent_videos).to eq([])
  end
end
