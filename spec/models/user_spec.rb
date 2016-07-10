require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password).on(:create) }

  describe '#enqueued_video?' do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    it "returns true if video in current user's queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.enqueued_video?(video)).to be_true
    end
    it "returns false if video is not in current user's queue" do
      expect(user.enqueued_video?(video)).to be_false
    end
  end
end