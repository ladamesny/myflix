require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "should set @queue_items with the queue items of the logged in user" do
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      session[:user_id] = user.id

      get :index

      expect(assigns(:queue_items)).to match_array(user.queue_items)
    end

    it "should redirect unauthenticated users to the sign in page" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    before do
      session[:user_id] = Fabricate(:user).id
      @video = Fabricate(:video)
    end
    it "redirects to the my queue page" do
      post :create, video_id: @video.id

      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      expect{post :create, video_id: @video.id}.to change{QueueItem.count}.by(1)
    end
    it "creates a queue item that is associated to the video" do
      post :create, video_id: @video.id

      expect(QueueItem.last.video.id).to eq(@video.id)
    end
    it "creates a queue item that is associated with the signed in user" do
      post :create, video_id: @video.id

      expect(QueueItem.last.user.id).to eq(session[:user_id])
    end
    it "puts the video as the last one in the queue" do
      post :create, video_id: @video.id
      user = User.find(session[:user_id])
      expect(QueueItem.last.position).to eq(user.queue_items.count)
    end
    it "does not add the video to the queue if the video is in the queue already" do
      user = User.find(session[:user_id])
      Fabricate(:queue_item, video: @video, user: user)
      post :create, video_id: @video.id
      queue_count = user.queue_items.where(video: @video).count
      expect(queue_count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do
      session[:user_id] = nil
      post :create, video_id: @video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)

      delete :destroy, id: queue_item.id

      expect(response).to redirect_to my_queue_path
    end
    it "removes the enqueued video from my queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)

      delete :destroy, id: queue_item.id

      expect(user.queue_items.where(video: video)).to be_empty
    end
    it "deletes the queue item from the database" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)

      delete :destroy, id: queue_item.id

      expect(QueueItem.count).to eq(0)
    end
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      marie = Fabricate(:user)
      larry = Fabricate(:user)
      session[:user_id] = larry.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: marie)

      delete :destroy, id: queue_item.id

      expect(QueueItem.count).to eq(1)
    end
    it "updates the positions of the remaining videos in my queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      new_queue_item = Fabricate(:queue_item, user: user)

      delete :destroy, id: queue_item.id
      new_queue_item.reload

      expect(new_queue_item.position).to eq(user.queue_items.count)
    end
    it "redirects to the sign in page for unauthenticated users" do
      session[:user_id] = nil
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id

      expect(response).to redirect_to sign_in_path
    end
  end
end
