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
end
