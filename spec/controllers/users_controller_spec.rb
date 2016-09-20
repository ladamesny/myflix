require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "builds a new user" do
      get :new
      user = User.new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do

    context "with valid input" do
      it "creates a new user record" do
        expect{ post :create, user: Fabricate.attributes_for(:user) }.to change{ User.count }.from(0).to(1)
      end

      it "redirects to sign_in_path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
      end
      it "should not create the new user" do
        expect(User.count).to eq(0)
      end

      it "should render the new template" do
        expect(response).to render_template :new
      end
      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      sign_in_user
      larry = Fabricate(:user)
      get :show, id: larry.id
      expect(assigns(:user)).to eq(larry)
    end
  end
end
