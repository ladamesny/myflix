require 'spec_helper'

describe QueueItemsController do
  before {sign_in_user}

  describe "GET index" do
    it "should set @queue_items with the queue items of the logged in user" do
      queue_item1 = Fabricate(:queue_item, user: current_user)
      queue_item2 = Fabricate(:queue_item, user: current_user)

      get :index

      expect(assigns(:queue_items)).to match_array(current_user.queue_items)
    end
    it_behaves_like "require sign in" do
      let(:action) {get :index}
    end
  end

  describe "POST create" do
    let(:video) {Fabricate(:video)}

    it "redirects to the my queue page" do
      post :create, video_id: video.id

      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      expect{post :create, video_id: video.id}.to change{QueueItem.count}.by(1)
    end
    it "creates a queue item that is associated to the video" do
      post :create, video_id: video.id

      expect(QueueItem.last.video.id).to eq(video.id)
    end
    it "creates a queue item that is associated with the signed in user" do
      post :create, video_id: video.id

      expect(QueueItem.last.user.id).to eq(session[:user_id])
    end
    it "puts the video as the last one in the queue" do
      post :create, video_id: video.id
      expect(QueueItem.last.position).to eq(current_user.queue_items.count)
    end
    it "does not add the video to the queue if the video is in the queue already" do
      Fabricate(:queue_item, video: video, user: current_user)
      post :create, video_id: video.id
      queue_count = current_user.queue_items.where(video: video).count
      expect(queue_count).to eq(1)
    end
    it_behaves_like "require sign in" do
      let(:action) {post :create, video_id: video.id}
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      queue_item = Fabricate(:queue_item)

      delete :destroy, id: queue_item.id

      expect(response).to redirect_to my_queue_path
    end
    it "removes the enqueued video from my queue" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)

      delete :destroy, id: queue_item.id

      expect(current_user.queue_items.where(video: video)).to be_empty
    end
    it "deletes the queue item from the database" do
      queue_item = Fabricate(:queue_item, user: current_user)

      delete :destroy, id: queue_item.id

      expect(QueueItem.count).to eq(0)
    end
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      marie = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: marie)

      delete :destroy, id: queue_item.id

      expect(QueueItem.count).to eq(1)
    end
    it "normalizes the queue item position numbers" do
      queue_item = Fabricate(:queue_item, user: current_user)
      new_queue_item = Fabricate(:queue_item, user: current_user)

      delete :destroy, id: queue_item.id
      new_queue_item.reload

      expect(new_queue_item.position).to eq(current_user.queue_items.count)
    end
    it_behaves_like "require sign in" do
      let(:queue_item) {Fabricate(:queue_item, user: current_user)}
      let(:action) {delete :destroy, id: queue_item.id}
    end
  end

  describe "POST update_queue" do
    let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1)}
    let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2)}

    context "with valid inputs" do
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

        expect(current_user.queue_items).to match_array([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2}]

        expect(current_user.queue_items.map(&:position)).to match_array([1, 2])
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
      it_behaves_like "require sign in" do
        let(:action) {post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]}
      end
      it "does not update the position number" do
        sign_out_user
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]

        expect([queue_item1.reload.position, queue_item2.reload.position]).to match_array([1, 2])
      end
    end
    context "with queue items that do not belong to the current user" do
      let(:marie) {Fabricate(:user)}

      it "redirects to my queue page" do
        queue_item1 = Fabricate(:queue_item, user: marie, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marie, position: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not update the other user's queue item list" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marie, position: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(queue_item2.reload.position).to eq(2)
      end
    end
  end
end
