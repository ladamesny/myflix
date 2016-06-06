class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  before_action :prepare_review_values, only: [:show]
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @review = Review.new
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_img, :large_img )
  end

  def set_video
    @video = Video.find(params[:id])
  end

  def prepare_review_values
    @reivew_values = [
      { value: 1, label: '1 Star' },
      { value: 2, label: '2 Star' },
      { value: 3, label: '3 Star' },
      { value: 4, label: '4 Star' },
      { value: 5, label: '5 Star' }
    ]
  end

  # def require_creator
  #   unless logged_in? and (current_user == @video.creator || current_user.admin?)
  #     flash[:error] = "You're not allowed to do that."
  #     redirect_to posts_path
  #   end
  # end

  # def same_user?
  #   if current_user == @video.creator
  #     true
  #   else
  #     false
  #   end
  # end
end
