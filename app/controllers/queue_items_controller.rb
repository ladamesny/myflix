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

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy! if current_user.queue_items.include?(queue_item)
    normalize_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Not a valid position number. Please try again."
    end
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

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position]) if queue_item.user == current_user
      end
    end
  end

  def normalize_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
end
