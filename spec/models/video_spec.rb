require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end

describe '#search_by_title' do
  it "should return an empty array" do
    expect(Video.search_by_title("Batman")).to eq([])
  end

  it "should return one matches" do
    batman = Video.create(title: "Batman", description: "First Batman")
    Video.create(title: "The Dark Knight", description: "Best Batman")
    expect(Video.search_by_title("Batman")).to eq([batman])
  end

  it "should return two matches" do
    batman = Video.create(title: "Batman", description: "First Batman")
    batman_returns = Video.create(title: "Batman Returns", description: "Second Batman")
    Video.create(title: "The Dark Knight", description: "Best Batman")
    expect(Video.search_by_title("Batman")).to eq([batman, batman_returns])
  end
end
