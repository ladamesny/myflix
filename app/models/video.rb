class Video < ActiveRecord::Base
  has_many :reviews
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title search_term
    return [] if search_term.blank?
    where("LOWER(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end

  def average_rating
    return 0 if reviews.count.zero?
    average = 0
    reviews.each { |review| average+=review.rating }
    (average/reviews.count).to_f
  end

  def reviews_for_show
    reviews.order('created_at', 'desc')
  end
end
