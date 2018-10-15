class SoundcloudTracksController < ApplicationController
  include SoundcloudTracksImport

  before_action :authenticate!
  before_action :check_beat_deficit
  before_action :check_client
  before_action :count_tracks, only: :index

  PAGE_SIZE = 5

  def index
    result = params[:url] ? client.get(params['url']) : client.get('/me/tracks', limit: PAGE_SIZE, linked_partitioning: params[:page])
    @tracks = result['collection']
    @next_href = result['next_href']
    @count_tracks = params[:count_tracks] unless @count_tracks
    @show_link = @count_tracks.to_i > PAGE_SIZE
  end

  def create
    return redirect_to soundcloud_tracks_path, notice: t('.check') unless import_tracks[:ids]
    import_tracks[:ids].each do |id|
      data = client.get("/tracks/#{id}")
      track = current_user.tracks.new track_params(data)
      Shortener::ShortenedUrl.generate("/tracks/#{track.id}") if track.save(validate: false)
    end
    @count_tracks = import_tracks[:count_tracks]
    redirect_to soundcloud_tracks_path, notice: t('.success')
  end

  private

  def client
    @client ||= SoundCloud.new(access_token: identity.access_token)
  end

  def identity
    @identity ||= current_user.identities.find_by(provider: 'soundcloud')
  end

  def import_tracks
    params.require(:import_tracks).permit(:count_tracks, ids: [])
  end

  def check_client
    return redirect_to session_sound_cloud_path unless identity
    client = SoundCloudService.new(expires_at: identity.expires_at).client
    SoundCloudService.new(refresh_token: identity.refresh_token).refresh_token(identity) if client.expired?
  end
end
