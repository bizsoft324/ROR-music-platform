class TracksController < ApplicationController
  before_action :track, only: %i[new edit]
  before_action :genres, only: %i[new edit]
  before_action :authenticate!, only: %i[new edit]

  def show
    @my_tracks = Array.new(1, @track)
    @likes_count = @track.likes.count
    @dislikes_count = @track.dislikes.count
    @indifferences_count = @track.indifferences.count
    @has_like = Rating.find_by(user: current_user, track: @track).present?

    @comments = @track.comment_threads
    @comment = Comment.new
  end

  def new
    @page_title = 'upload a beat'
    respond_to do |format|
      format.html
      format.json { render json: Genre.find_by(id: params[:genre_id])&.subgenres }
    end
  end

  def create
    @track = current_user.tracks.new(track_params)

    @track.update_with_tag_list(tag_list)

    if @track.save
      SlackNotifierJob.perform_later(message: t('.track_uploaded', username: current_user.username, title: @track.title))
      Shortener::ShortenedUrl.generate("/tracks/#{@track.id}", owner: @track)
      Tracker.track(@track.name, 'Upload')
      redirect_to artist_track_list_path(current_user.id), notice: t('.success')
    else
      genres
      flash[:danger] = error_message
      redirect_to new_track_path
    end
  end

  def update
    respond_to do |format|
      if track.update track_params
        format.json { head :ok }
        format.html do
          redirect_to artist_track_list_path(current_user.id),
                      notice: t('.success')
        end
      else
        genres
        format.json { head :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end

  def destroy
    track.destroy! if current_user == track.user
    respond_to do |format|
      format.html do
        redirect_to artist_track_list_path(current_user.id),
                    notice: t('.success')
      end
    end
  end

  # Updates mobile fixed player with current track
  def update_player
    @current_track = track
    respond_to do |format|
      format.js
    end
  end

  private

  def track_params
    params.require(:track).permit(:tag_list, :audio, :image, :cached_image_data, :user_id,
                                  :audio_remote_url, :image_remote_url, :title, :description, :streamable,
                                  :contactable, :has_vocals, :downloadable, :has_samples, :sharing, genre_ids: [],
                                                                                                    subgenre_ids: [])
  end

  def genres
    @genres ||= Genre.all
  end

  def track
    @track ||= Track.where(id: params[:id]).first_or_initialize
  end

  def error_message
    @track.errors.messages[:audio].grep(/type/).any? ? 'This type is not allowed' : 'Track is way too large'
  end

  def tag_list
    @tag_list ||= params[:track][:tag_list]
  end
end
