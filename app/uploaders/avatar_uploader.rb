class AvatarUploader < CarrierWave::Uploader::Base
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

  def public_id
    model.username
  end

  def default_url(*_args)
    ActionController::Base.helpers.image_path('image.png')
  end
end
