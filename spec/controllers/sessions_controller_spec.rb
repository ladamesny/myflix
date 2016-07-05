require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to videos_path if already signed in" do
      sign_in_user
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      let(:user) {Fabricate(:user)}
      before {post :create, email: user.email, password: user.password}

      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end

      it "signs in the user" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid attribtues" do
      let(:user) {Fabricate(:user)}
      it "does not set the user in the session" do
        post :create, email: user.email, password: nil
        expect(session[:user_id]).to be_nil
      end

      it "sets the error message" do
        post :create, email: user.email, password: nil
        expect(flash[:error]).not_to be_blank
      end

      it_behaves_like "require sign in" do
        let(:action) {post :create, email: user.email, password: nil}
      end
    end
  end

  describe "DELETE destroy" do
    before {sign_in_user}

    it "removes user id from session" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root_path" do
      get :destroy
      expect(response).to redirect_to root_path
    end

    it "sets notice" do
      get :destroy
      expect(flash[:notice]).not_to be_blank
    end
  end
end
