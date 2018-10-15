module SoundcloudTracksImport
  extend ActiveSupport::Concern

  private

  def track_params(track)
    audio_data = data_from_url(track.download_url)
    title = track.title.delete(' ')
    { title: track.title,
      description: track.description,
      audio: uploaded_file(audio_data, [track.title.delete(' '), ".#{track.original_format}"]),
      image: uploaded_file(open(track.artwork_url || track.user.avatar_url).read, [title]),
      soundcloud_uri: track.id }
  end

  def uploaded_file(data, title)
    file = Tempfile.new(title, encoding: 'ascii-8bit')
    file.write(data)
    type = MimeMagic.by_magic(data).type
    ActionDispatch::Http::UploadedFile.new(tempfile: file.open, filename: title.join, type: type)
  end

  def data_from_url(url)
    client.get(url)
  end

  def count_tracks
    @count_tracks = client.get('/me/tracks').size unless params[:url]
  end

  def check_beat_deficit
    return redirect_to new_track_path if current_user.commented_tracks.count <= current_user.track_count - 20
  end
end
