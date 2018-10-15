require 'image_processing/mini_magick'

class Shrine
  MAX_FILESIZE = 10.megabytes # redefine in subclasses if needed
  MIME_TYPES = [].freeze # subclass must have it's own types defined
  IS_LOCAL = Rails.env.test? || Rails.env.development? && ENV.key?('LOCAL_UPLOADS')
  plugin :logging, logger: Rails.logger

  # TODO: check is released https://github.com/janko-m/shrine/issues/57
  concerning :Patches do
    class_methods do
      def inherited(subclass)
        super
        subclass.logger = logger
      end
    end
  end

  %i[activerecord pretty_location validation_helpers determine_mime_type remove_attachment
     cached_attachment_data restore_cached_data remove_invalid delete_raw multi_delete rack_file
     hooks]
    .each { |name| plugin name }

  Attacher.validate do # TODO: collect inherited validation blocks for subclasses
    validate_mime_type_inclusion shrine_class::MIME_TYPES
    validate_max_size shrine_class::MAX_FILESIZE
  end

  require 'shrine/storage/s3'

  s3_options = {
    region:            'us-east-1',
    upload_options:    { acl: 'public-read' },
    bucket:            ENV['AWS_BUCKET'],
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }

  if IS_LOCAL
    require 'shrine/storage/file_system'

    self.storages = {
      cache:  Shrine::Storage::FileSystem.new('public', prefix: "uploads/#{Rails.env}/"),
      store:  Shrine::Storage::FileSystem.new('public', prefix: "uploads/#{Rails.env}/")
    }

  else

    self.storages = {
      cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
      store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)
    }
  end
end
