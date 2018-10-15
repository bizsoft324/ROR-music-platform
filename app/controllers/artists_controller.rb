class ArtistsController < ApplicationController
  def track_list
    @artist_tracks = artist.tracks.includes(:by_week_chart).sorted_by_sort_name(params[:order])
    @page_title = 'user tracks'

    if @artist_tracks.empty? && !@artist.verified?
      redirect_to new_track_path
      flash[:notice] = "You don't have a profile, yet! You need to upload tracks first."
    end
  end

  private

  def artist
    @artist ||= User.find(params[:artist_id])
  end
end
