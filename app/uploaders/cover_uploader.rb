class CoverUploader < CarrierWave::Uploader::Base
  if Rails.env.development? || Rails.env.test?

    include CarrierWave::MiniMagick

    version :thumb do
      process resize_to_fill: [100, 100]
    end

    version :square do
      process resize_to_fill: [200, 200]
    end

    version :medium do
      process resize_to_fill: [300, 300]
    end

  else

    include Cloudinary::CarrierWave

    version :thumb do
      resize_to_fill(100, 100)
    end

    version :square do
      resize_and_pad(200, 200)
    end

    version :medium do
      resize_to_fill(300, 300)
    end
  end
end
