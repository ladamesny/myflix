class User < ActiveRecord::Base
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order(:position) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followee_relationships,  class_name: "Relationship", foreign_key: "leader_id"
  validates_presence_of :email, :full_name, :username
  validates_presence_of :password, on: :create
  validates_uniqueness_of :email, :username

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def enqueued_video?(video)
    queue_items.map{|queue_item| queue_item.video}.include?(video)
  end

  def video_collection
    queue_items.map{|qi| qi.video}
  end

  def leaders
    following_relationships.map{|r| r.leader }
  end

  def followers
    followee_relationships.map{|r| r.follower}
  end

  def can_follow?(another_user)
    !(leaders.include?(another_user) || another_user == self)
  end

end
