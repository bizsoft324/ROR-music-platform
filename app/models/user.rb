class User < ActiveRecord::Base
  include VerifierConcern
  include Utility

  mount_base64_uploader :avatar, AvatarUploader

  enum roles: %i[user admin]

  has_many :comments, dependent: :destroy
  has_many :critiques_comments, through: :tracks, source: :critiques_comments
  has_many :tracks, counter_cache: :count_of_tracks, dependent: :destroy
  has_many :ratings,    dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :track_comments, -> { where(commentable_type: 'Track') }, class_name: Comment
  has_many :commented_tracks, -> { uniq }, through: :track_comments, source: :commentable, source_type: Track
  has_many :badges, as: :badge_duty, dependent: :destroy
  has_many :artist_subdomains, dependent: :destroy

  accepts_nested_attributes_for :identities

  validates :email,     uniqueness: true, presence: true
  validates :email,     format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :username,  uniqueness: true, length: { minimum: 4 }, presence: true
  validates :username,  format: { with: /\A^[a-zA-Z][-a-zA-Z0-9_.]+\Z/ }
  validates :first_name, :last_name, :city, :country, presence: true
  validates :password,  presence: true, if: -> { password_digest.blank? }
  validates :password,  length: { minimum: 8 }, if: -> { password.present? }

  has_secure_password
  has_secure_token :auth_token

  after_save :confirm_email, :set_activity
  after_create :set_default_avatar

  def verified?
    badges.select { |badge| badge.description == 'verified' }.present?
  end

  def increase_rating(track)
    rating = track.rating + 1
    update_rating(track, rating)
  end

  def decrease_rating(track)
    rating = track.rating - 1
    update_rating(track, rating)
  end

  def update_rating(track, rating)
    total_shares = track.permalink ? SocialShares.total(track.permalink) : 0

    rating += track.social_shares >= total_shares ? track.social_shares - total_shares : total_shares

    track.update(rating: rating, social_shares: total_shares)
  end

  def self.fetch_identity(identity_params, user_params)
    identity = Identity.find_by_provider_uid(identity_params[:provider], identity_params[:uid]).first
    user = identity&.user
    if user
      user.update(user_params)
      identity.update(identity_params)
      return user
    end
    user = new(user_params)
    user.save(validate: false)
    user.identities.create(identity_params)
    user
  end

  def confirm!
    update_column(:confirmed, true)
  end

  def name
    if first_name == last_name
      first_name
    else
      "#{first_name} #{last_name}"
    end
  end

  def mailboxer_email(_object)
    nil
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save(validate: false)
    UserMailer.reset_password(self).deliver_later
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end

  def tester_id
    identity = identities.find_by(provider: 'prefinery')
    return raise StandardError, 'No Prefinery identity found.' unless identity
    identity.uid
  end

  def current_tester?
    identities.where(provider: 'prefinery').present? && identities.find_by(provider: 'prefinery').uid.present?
  end

  def position
    identities.find_by(provider: 'prefinery') ? identities.find_by(provider: 'prefinery')&.access_token : '2500'
  end

  def missing_password?
    password_digest.blank? || %i[password password_confirmation].any? { |a| errors.include?(a) }
  end

  def check_uniq_email
    valid?
    self.email = nil if errors.include?(:email)
  end

  def artist_info
    [username, city, country].join(', ')
  end

  def location
    [city, country].join(', ')
  end

  def track_count
    tracks.count
  end

  def change_avatar_by_url(avatar_url)
    update_attribute(remote_avatar_url, avatar_url)
  rescue
    puts 'Not found'
  end

  def provider
    identities.last&.provider
  end

  def fullname?
    first_name.present? && last_name.present?
  end

  def send_daily_emails
    return unless Time.zone.now.hour == 9
    user = User.find(id)
    UserMailer.charts_update(user).deliver_later if chart_position_changed(user)
  end

  def chart_position_changed(user)
    Utility.search_hash(user.email_data, 'moved')
  end

  private

  def confirm_email
    return unless changed.include?('email')
    token = verifier.generate(id: id)
    update_column(:confirmed, false)
    UserMailer.confirmation(self, token).deliver_later
  end

  def set_default_avatar
    return if self[:avatar].present?
    assign_attributes(avatar: data_default_avatar)
    save(validate: false)
  end

  def data_default_avatar
    regex = %r{\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)\Z}
    data_uri_parts = Identicon.data_url_for(username, 300).match(regex)
    title = username || 'user_avatar'
    file = Tempfile.new(title, encoding: 'ascii-8bit')
    file.write(Base64.decode64(data_uri_parts[2]))
    ActionDispatch::Http::UploadedFile.new(tempfile: file.open, filename: title, type: data_uri_parts[1])
  end

  def set_activity
    update_column(:last_activity_at, Time.now)
  end
end
