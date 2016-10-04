require "spec_helper"

describe RelationshipsController do
  let(:larry)        { Fabricate(:user) }
  let(:johnny)       { Fabricate(:user) }
  let(:chris)        { Fabricate(:user) }
  let(:relationship) { Fabricate(:relationship, leader: johnny, follower: larry) }

  describe "GET index" do
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
    
    it "sets @relationships to the user's leaders" do
      sign_in_user(larry)
      get :index
      
      expect(assigns(:relationships)).to match_array(larry.following_relationships)
    end
  end
 

  describe "POST create" do
    let(:larry)  { Fabricate(:user) }
    let(:johnny) { Fabricate(:user) }
    let(:chris)  { Fabricate(:user) }

    before { sign_in_user(larry) }

     it_behaves_like "require sign in" do
      let(:action) { post :create, leader_id: johnny }
    end
 
    it "allows the signed in user to follow another user" do
      post :create, leader_id: johnny
      expect(larry.leaders).to include(johnny)
      expect(chris.leaders).not_to include(johnny)
    end
    it "does not create a relationship if one already exists" do
      Relationship.create(leader_id: johnny.id, follower_id: larry.id)
      post :create, leader_id: johnny
      expect(Relationship.where(leader_id: johnny.id, follower_id: larry.id).count).to eq(1)
    end
    it "does not allow a user to follow itself" do
      post :create, leader_id: larry.id

      expect(larry.leaders).not_to include(larry)
    end

    it "redirects the user to the relationships path" do
      post :create, leader_id: johnny
      expect(response).to redirect_to relationships_path
    end
  end

  describe "DELETE destroy" do
    it "deletes relationship if the current_user is the follower" do
       sign_in_user(larry)
       delete :destroy, id: relationship.id

       expect(Relationship.count).to eq(0)
    end
    
    it "does not delete the relationship if the current_user is not the follower" do
      sign_in_user(chris)
      delete :destroy, id: relationship.id

      expect(Relationship.count).to eq(1)
    end

    it "redirects the user to people_path" do
      sign_in_user(larry)
      delete :destroy, id: relationship.id

      expect(response).to redirect_to people_path
    end
 
    it_behaves_like "require sign in" do
      let(:action) { get :destroy, id: relationship.id}
    end
  end
end
