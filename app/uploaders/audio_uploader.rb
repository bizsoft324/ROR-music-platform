class AudioUploader < Shrine
  MAX_FILESIZE = 50.megabytes

  MIME_TYPES = %w(audio/mpeg audio/x-wav audio/mp3 audio/ogg audio/x-aiff audio/flac application/octet-stream).freeze # validate type
  plugin :direct_upload, max_size: MAX_FILESIZE, presign: true
  plugin :remote_url,    max_size: MAX_FILESIZE
  plugin :hooks

  Attacher.validate do
    validate_max_size shrine_class::MAX_FILESIZE
    validate_mime_type_inclusion shrine_class::MIME_TYPES
  end

  plugin :included do |name|
    UPLOAD_PATHS = HashWithIndifferentAccess.new unless defined?(UPLOAD_PATHS)
    UPLOAD_PATHS[name] = "/upload/audio/cache/#{IS_LOCAL ? name : 'presign'}".freeze
    define_singleton_method("#{name}_upload_path") { UPLOAD_PATHS[name] }
    delegate "#{name}_upload_path", to: :class
  end

  # applies "peaks" to Track.waveform
  plugin :included do |name|
    after_save do
      if send("#{name}_data_changed?") && send(name) && send(name).storage_key == 'cache'
        update_columns(waveform: send(name).metadata['peaks'])
      end
    end
  end

  # calculates peaks from audio file and attaches as an array to the files metadata
  def around_upload(io, context)
    @super_audio = super

    return unless context[:phase] == :cache

    path  = io.respond_to?(:tempfile) ? io.tempfile.path : io.path
    audio = FFMPEG::Movie.new(path)
    wav   = Tempfile.new(['forwaveform', '.wav'])

    return unless audio_valid?(audio)
    audio.transcode(wav.path)

    peaks         = []
    length        = 60
    info          = WaveFile::Reader.info(wav.path)
    sample_size   = info.sample_frame_count / length

    WaveFile::Reader.new(wav.path, WaveFile::Format.new(:mono, :float, 44_100)) do |reader|
      reader.each_buffer(sample_size) do |buffer|
        intermediary = []
        steps = buffer.samples.length / 10
        (0..9).each do |step|
          intermediary.push(buffer.samples[step * steps].round(2))
        end
        peaks.push(intermediary.max)
        peaks.push(intermediary.min)
      end

      @super_audio.metadata.update('peaks' => peaks)
    end
  end

  def audio_valid?(audio)
    audio.audio_codec && audio.size < MAX_FILESIZE
  end
end
