class VideosController < ApplicationController
  before_action :set_video, only: [:show]

  def index
    @videos = Video.all
  end

  def show
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_img, :large_img )
  end

  def set_video
    @video = Video.find(params[:id])
  end
end