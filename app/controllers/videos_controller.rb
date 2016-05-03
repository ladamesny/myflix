class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
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
