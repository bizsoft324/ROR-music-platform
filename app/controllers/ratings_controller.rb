class RatingsController < ApplicationController
  def index
    @given_ratings = current_user.ratings.includes(:track).send_order(params[:sort])

    @received_ratings = []
    rating_ids = current_user.tracks.flat_map { |t| t.ratings.pluck(:id) }
    @received_ratings = Rating.where(id: rating_ids).send_order(params[:sort]) unless @received_ratings.empty?
  end

  def create_or_update
    if authenticated?
      rating = Rating.where(user_id: current_user.id, track_id: params[:track]).first_or_initialize
      rating.update_attributes!(status: Rating.statuses[params[:star]])
      SlackNotifierJob.perform_later(message: t('.rating_left', username: current_user.username, star: params[:star], track_title: track.title))
      Tracker.track(current_user.name,
                    'Create Critique',
                    critiques_on_track: track.critiques_count)
      render json: rating_count
    else
      render json: { error: 'Must be signed in leave ratings.' }
    end
  end

  private

  def rating_count
    {
      likes: track.like_count,
      dislikes: track.dislike_count,
      indifference: track.indifferent_count,
      star: params[:star]
    }
  end

  def track
    @track ||= Track.find(params[:track])
  end
end
