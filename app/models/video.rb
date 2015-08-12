class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title term
    return [] if term.blank?
    where("title LIKE ?", "%#{term}%").order("created_at DESC")
  end
end
