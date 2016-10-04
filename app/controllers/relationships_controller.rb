class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    @user = User.find(params[:leader_id])
    Relationship.create(leader_id: @user.id, follower_id: current_user.id) if current_user.can_follow?(@user)
    redirect_to relationships_path 
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower_id == current_user.id 
    redirect_to people_path
  end
end
