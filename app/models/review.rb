class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :user, :video
  validates_presence_of :body, unless: :on_my_queue_page?
  validates_numericality_of :rating, only_integer: true
  validates_inclusion_of :rating, :in => 1..5

  attr_accessor :on_my_queue_page

  private

  def on_my_queue_page?
    on_my_queue_page == true || on_my_queue_page == 'true'
  end
end
