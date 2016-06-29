require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe '#video_title' do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Batman")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Batman")
    end
  end

  describe '#rating' do
    it "returns the rating of the users rating for the associated video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if there are no ratings" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to be_nil
    end
  end

  describe '#category_name' do
    it "returns the category name of the associated video" do
      category = Fabricate(:category, name: "action")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category_name).to eq("action")
    end
  end

  describe '#category' do
    it "returns the category of the associated video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category).to eq(category)
    end
  end
end
