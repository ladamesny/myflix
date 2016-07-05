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
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}

    it "returns the rating of the users rating for the associated video" do
      Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if there are no ratings" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#rating=' do
    let(:larry) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}

    it "changes the rating of the review if the review is present" do
      review = Fabricate(:review, rating: 3, video: video, user: larry)
      queue_item = Fabricate(:queue_item, user: larry, video: video)
      queue_item.rating = 5
      expect(queue_item.reload.rating).to eq(5)
    end
    it "clears the rating of the review if the review is present" do
      review = Fabricate(:review, rating: 3, video: video, user: larry)
      queue_item = Fabricate(:queue_item, user: larry, video: video)
      queue_item.rating = nil
      expect(queue_item.reload.rating).to eq(nil)
    end
    it "creates a review with the rating if the review is not present" do
      queue_item = Fabricate(:queue_item, user: larry, video: video)
      queue_item.rating = 4
      expect(queue_item.reload.rating).to eq(4)
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
