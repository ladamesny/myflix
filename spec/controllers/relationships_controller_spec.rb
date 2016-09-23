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
 
  describe "DELETE destroy" do
    it "destroys follow relationship for selected user" do
       sign_in_user(larry)

       delete :destroy, id: relationship.id

       expect(Relationship.count).to eq(0)
    end
    
    it "does not destroy follow relationship for another user" do
      sign_in_user(chris)

      delete :destroy, id: relationship.id

      expect(Relationship.count).to eq(1)
    end

    it "redirects the user to people_path" do
      sign_in_user(larry)

      delete :destroy, id: relationship.id

      expect(response).to redirect_to people_path
    end
  end
end
