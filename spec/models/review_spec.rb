require 'spec_helper'

describe Review do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:rating) }

  describe '#cover_img' do
    it 'returns the url of the small image' do
      video = Fabricate(:video, small_img: 'abc')
      review = Fabricate(:review, video: video)
      expect(review.cover_img).to eq('abc')
    end
  end
end
