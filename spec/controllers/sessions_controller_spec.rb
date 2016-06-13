require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to videos_path if already signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      before do
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password
      end
      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end

      it "signs in the user" do
        expect(session[:user_id]).to eq(@user.id)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid attribtues" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: nil
      end

      it "does not set the user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "should redirect to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "DELETE destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
    end

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
