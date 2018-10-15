class ArtistSubdomainsController < ApplicationController
  before_action :find_subdomain, only: :show

  def show
    @artist_tracks = artist.tracks.includes(:by_week_chart).sorted_by_sort_name(params[:order])
    @page_title = 'user tracks'
    redirect_to new_track_path if @artist_tracks.empty?
  end

  private

  def find_subdomain
    @subdomain = ArtistSubdomain.find_by(slug: request.subdomain)
    redirect_to home_index_path unless @subdomain
  end

  def artist
    @artist ||= @subdomain.user
  end
end
