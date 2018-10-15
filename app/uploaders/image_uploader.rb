require 'image_processing/mini_magick'

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  MAX_FILESIZE = 10.megabytes
  MIME_TYPES = %w(image/jpg image/jpeg image/png image/gif)
  IMAGE_OPTIM = ImageOptim.new(pngout: false, svgo: false)
  VERSIONS = {
    preview: [400, 400],
    thumb: [173, 173]
  }.freeze

  plugin :direct_upload, presign: true
  plugin :store_dimensions
  plugin :remove_attachment
  plugin :versions
  plugin :remote_url, max_size: MAX_FILESIZE

  Attacher.validate do
    validate_max_size shrine_class::MAX_FILESIZE
    validate_mime_type_inclusion shrine_class::MIME_TYPES
  end

  def process(io, context)
    case context[:phase]
    when :store
      original = io.download

      Hash[*VERSIONS.flat_map{ |version, size|
        file = resize_to_limit(original, *size)
        optimize_image!(file)
        [version, file]
      }].merge(original: io)
    end
  end

  private

  def optimize_image!(image)
    IMAGE_OPTIM.optimize_image!(image)
  end
end
