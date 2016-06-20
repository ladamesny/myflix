class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    enqueue_video(video)
    redirect_to my_queue_path
  end

  private

  def enqueue_video video
    QueueItem.create(video: video, user: current_user, position: generate_last_position ) unless already_enqueued?(video)
  end

  def generate_last_position
    current_user.queue_items.count + 1
  end

  def already_enqueued?(video)
    current_user.queue_items.map{ |queue_item| queue_item.video.id.to_i }.include?(video.id.to_i)
  end
end
