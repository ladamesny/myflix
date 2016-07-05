require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:batman) { Fabricate(:video) }

    it "sets the @video variable for authenticated users" do
      sign_in_user
      get :show, id: batman.id
      expect(assigns(:video)).to eq(batman)
    end

    it "redirects unauthenticated users to the sign in page" do
      get :show, id: batman.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    let(:batman) { Fabricate(:video, title: "Batman") }
    it "sets @results for authenticated users" do
      sign_in_user
      post :search, search_term: 'man'
      expect(assigns(:results)).to eq([batman])
    end

    it "redirects unauthenticated users to the sign in page" do
      post :search, search_term: 'man'
      expect(response).to redirect_to sign_in_path
    end
  end
end
