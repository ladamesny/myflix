require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order(created_at: :desc) }


  describe '#search_by_title' do
    let(:batman) {Video.create(title: "Batman", description: "First Batman")}

    it "it returns an empty array if there is no match" do
      batman_returns = Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Hello")).to eq([])
    end

    it "returns an array of one video when it finds an exact match" do
      batman_returns = Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Batman")).to eq([batman])
    end

    it "returns an array of one video when it finds a partial match" do
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("man")).to eq([batman])
    end

    it "returns an array of one video when it finds a lowercase match" do
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("batman")).to eq([batman])
    end

    it "should returns an array of all matches ordered by create_at" do
      batman_returns = Video.create(title: "Batman Returns", description: "Second Batman")
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Batman")).to match_array([batman_returns, batman])
    end

    it "returns an empty array for search of empty string" do
      batman_returns = Video.create(title: "Batman Returns", description: "Second Batman")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe '#average_rating' do
    it 'returns average rating for movie' do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 4)
      Fabricate(:review, video: video, rating: 3)
      Fabricate(:review, video: video, rating: 2)

      expect(video.average_rating).to eq((4+3+2)/3)
    end
  end

  describe '#genre' do
    it 'returns the category name' do
      category = Fabricate(:category, name: "Action")
      video = Fabricate(:video, category: category)
      expect(video.genre).to eq('Action')
    end
  end
end

