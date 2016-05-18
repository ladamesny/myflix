require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title' do
    it "it returns an empty array if there is no match" do
      batman = Video.create(title: "Batman", description: "First Batman")
      batman_returns = Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Hello")).to eq([])
    end

    it "returns an array of one video when it finds an exact match" do
      batman = Video.create(title: "Batman", description: "First Batman")
      batman_returns = Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Batman")).to eq([batman])
    end

    it "returns an array of one video when it finds a partial match" do
      batman = Video.create(title: "Batman", description: "First Batman")
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("man")).to eq([batman])
    end

    it "returns an array of one video when it finds a lowercase match" do
      batman = Video.create(title: "Batman", description: "First Batman")
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("batman")).to eq([batman])
    end

    it "should returns an array of all matches ordered by create_at" do
      batman = Video.create(title: "Batman", description: "First Batman")
      batman_returns = Video.create(title: "Batman Returns", description: "Second Batman")
      Video.create(title: "The Dark Knight", description: "Best Batman")
      expect(Video.search_by_title("Batman")).to eq([batman_returns, batman])
    end

    it "returns an empty array for search of empty string" do
      batman = Video.create(title: "Batman", description: "First Batman")
      batman_returns = Video.create(title: "Batman Returns", description: "Second Batman")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end

