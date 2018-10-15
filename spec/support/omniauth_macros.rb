module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => :twitter,
      'uid' => '123545',
      'info' => {
        'name' => 'John Smith',
        'nickname' => 'JohnSmith',
        'image' => 'localhost/avatar'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
  end

  def mock_soundcloud_identity_params
    Hashie::Mash.new(
      'provider' => :soundcloud,
      'uid' => '123545',
      'access_token' => 'valid_token',
      'expires_in' => (Time.zone.now + 4.hours).to_i,
      'avatar_url' => mock_image_url
    )
  end

  def mock_soundcloud_user_params
    Hashie::Mash.new(
      'username' => 'JohnSmith',
      'first_name' => 'John',
      'last_name' => 'Smith',
      'confirmed' => true
    )
  end

  def mock_soundcloud_user_params_without_name
    Hashie::Mash.new(
      'username' => 'JohnSmith',
      'first_name' => '',
      'last_name' => '',
      'confirmed' => true
    )
  end

  def mock_track_collection_params
    { 'collection' => [mock_track_params] }
  end

  def mock_track_params(open_image = false)
    OpenStruct.new( id: '123456',
      artwork_url: mock_image_url,
      title: 'Best audio',
      description: 'first audio',
      download_url: mock_audio_url,
      genre: 'jazz',
      original_format: 'mp3',
      collection: [])
  end

  def mock_data_file(file_path)
    open(file_path).read
  end

  def mock_image_url
    "#{Rails.root}/spec/fixtures/images/artofcool.jpg"
  end

  def mock_audio_url
    "#{Rails.root}/spec/fixtures/art_of_cool.mp3"
  end
end
