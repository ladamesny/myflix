require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password).on(:create) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order('created_at DESC') }

  let(:user) {Fabricate(:user)}

  describe '#enqueued_video?' do
    let(:video) {Fabricate(:video)}
    it "returns true if video in current user's queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.enqueued_video?(video)).to be_true
    end
    it "returns false if video is not in current user's queue" do
      expect(user.enqueued_video?(video)).to be_false
    end
  end

  describe '#video_collection' do
    let(:batman) {Fabricate(:video)}
    let(:superman) {Fabricate(:video)}
    let(:spiderman) {Fabricate(:video)}

    it "returns a list of videos in the user's queue" do
      Fabricate(:queue_item, user: user, video: batman)
      Fabricate(:queue_item, user: user, video: superman)
      Fabricate(:queue_item, user: user, video: spiderman)
      expect(user.video_collection).to match_array([batman, superman, spiderman])
    end
  end

  describe '#can_follow?' do
    let(:larry)  { Fabricate(:user) }
    let(:johnny) { Fabricate(:user) }

    it "returns false if already following the user" do
      Fabricate(:relationship, leader_id: johnny.id, follower_id: larry.id) 
      expect(larry.can_follow?(johnny)).to be_false
    end
    it "returns false if the user is current user"
    it "returns true if not following the user"
  end
end
