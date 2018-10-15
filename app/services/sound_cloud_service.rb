class SoundCloudService
  attr_reader :client, :code

  def initialize(attrs = {})
    @code = attrs.delete(:code)
    @client = SoundCloud.new(sound_cloud_attrs.merge(attrs))
  end

  def find_or_create_user
    identity = Identity.find_by(provider: 'soundcloud', uid: soundcloud_user['id'])
    if identity&.user
      identity.update!(identity_attrs)
      identity.user
    else
      create_user
    end
  end

  def connect_account(user)
    identity = user.identities.find_or_initialize_by(provider: 'soundcloud')
    identity.update!(identity_attrs)
  end

  def refresh_token(identity)
    identity.update!(expires_at: client.expires_at,
                     access_token: client.access_token,
                     refresh_token: client.refresh_token)
  end

  private

  def soundcloud_session
    @soundcloud_session ||= client.exchange_token(code: code)
  end

  def soundcloud_user
    @soundcloud_user ||= SoundCloud.new(access_token: soundcloud_session.access_token).get('/me')
  end

  def create_user
    user = User.new(
      username: normalise_username,
      first_name: soundcloud_user.first_name,
      last_name: soundcloud_user.last_name,
      confirmed: true,
      identities_attributes: [identity_attrs.merge(uid: soundcloud_user.id)]
    )
    user.save(validate: false)
    user.change_avatar_by_url(soundcloud_user.avatar_url)
    user
  end

  def identity_attrs
    {
      provider: 'soundcloud',
      access_token: soundcloud_session.access_token,
      refresh_token: soundcloud_session.refresh_token,
      avatar_url: soundcloud_user.avatar_url,
      expires_at: soundcloud_session.expires_in.seconds.from_now
    }
  end

  def sound_cloud_attrs
    {
      client_id: ENV['SC_CLIENT_ID'],
      client_secret: ENV['SC_CLIENT_SECRET']
    }
  end

  def normalise_username
    username = soundcloud_user.username.gsub(/\s+/, '')
    username_taken = User.find_by_username(username).present?
    username_taken ? [username, SecureRandom.hex(2)].join('_') : username
  end
end
