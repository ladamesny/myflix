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
    it "normalizes the queue item position numbers" do
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

  describe "POST update_queue" do
    context "only a single user" do
      let(:larry) {Fabricate(:user)}
      let(:queue_item1) {Fabricate(:queue_item, user: larry, position: 1)}
      let(:queue_item2) {Fabricate(:queue_item, user: larry, position: 2)}
      before do
        session[:user_id] = larry.id
      end
      context "with valid inputs" do
        it "redirects to my queue page" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

          expect(response).to redirect_to my_queue_path
        end

        it "reorders the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

          expect(larry.queue_items).to match_array([queue_item2, queue_item1])
        end

        it "normalizes the position numbers" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2}]

          expect(larry.queue_items.map(&:position)).to match_array([1, 2])
        end
      end
      context "with invalid inputs" do
        it "redirects to the my queue page" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1},{id: queue_item2.id, position: 1}]

          expect(response).to redirect_to my_queue_path
        end
        it "sets the flash error message" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1},{id: queue_item2.id, position: 1}]

          expect(flash[:error]).to be_present
        end
        it "does not update the positions" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1},{id: queue_item2.id, position: 1}]

          expect([queue_item1.reload.position, queue_item2.reload.position]).to match_array([1, 2])
        end
      end
      context "with unauthenticated users" do
        it "redirects to sign in path" do
          session[:user_id] = nil
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

          expect(response).to redirect_to sign_in_path
        end
        it "does not update the position number" do
          session[:user_id] = nil

          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

          expect([queue_item1.reload.position, queue_item2.reload.position]).to match_array([1, 2])
        end
      end
    end
    context "with queue items that do not belong to the current user" do
      it "redirects to my queue page" do
        larry = Fabricate(:user)
        marie = Fabricate(:user)
        session[:user_id] = larry.id
        queue_item1 = Fabricate(:queue_item, user: marie, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marie, position: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not update the other user's queue item list" do
        larry = Fabricate(:user)
        marie = Fabricate(:user)
        session[:user_id] = larry.id
        queue_item1 = Fabricate(:queue_item, user: larry, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marie, position: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(queue_item2.reload.position).to eq(2)
      end
    end
  end
end
