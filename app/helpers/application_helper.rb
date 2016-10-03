module ApplicationHelper
  def options_for_rating selected=nil
    options_for_select([1,2,3,4,5].map {|number| [pluralize(number, 'Star'), number] }, selected)
  end
  
  def follow_text user
    relationship = Relationship.where(leader_id: user.id, follower_id: current_user.id) 
    relationship.empty? ? "Follow" : "Following"
  end
end
