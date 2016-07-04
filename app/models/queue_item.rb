class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  validates_numericality_of :position, only_integer: true

  def rating
    review.rating if review
  end

  def rating=new_rating
    if review
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(rating: new_rating, video: self.video, user: self.user)
      new_review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  private

  def review
    @review ||= Review.where(user: user, video: video).first
  end
end
