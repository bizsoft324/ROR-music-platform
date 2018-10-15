class Track < ActiveRecord::Base
  include AudioUploader[:audio]
  include ImageUploader[:image]
  mount_base64_uploader :cover, CoverUploader

  include TrackFilter

  belongs_to :user
  belongs_to :artist_type
  has_many :ratings, dependent: :destroy
  has_many :critiques, dependent: :destroy
  has_many :critiques_comments, through: :critiques, source: :comments
  has_many :comments
  has_many :users, through: :comments
  has_many :subgenres_genre, -> { order('subgenres.id') }, through: :genres, source: :subgenres
  has_many :track_charted, class_name: Track::Charted, dependent: :destroy
  has_many :likes, class_name: Rating
  has_many :dislikes, class_name: Rating
  has_many :indifferents, class_name: Rating
  has_many :badges, as: :badge_duty, dependent: :destroy

  has_and_belongs_to_many :genres, dependent: :destroy
  has_and_belongs_to_many :subgenres, dependent: :destroy

  validates :title, :description, :image_data, presence: true

  after_create :track_count

  acts_as_commentable
  has_shortened_urls

  include PgSearch
  pg_search_scope :quick_search,
                  against: %i[title description tag_list],
                  associated_against: {
                    user: %i[username first_name last_name city country]
                  },
                  using: { tsearch: { prefix: true, dictionary: 'english' } }

  scope :default_order, (-> { order(updated_at: :desc) })

  scope :rating_gte, (->(rating) { where('rating >= ?', rating.to_i) })

  scope :sorted_by, (lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("tracks.created_at #{direction}")
    when /^rating/
      order("tracks.rating #{direction}")
    when /^charted/
      order('rating DESC').limit(100)
    else
      raise ArgumentError, "Invalid sort option: #{sort_option.inspect}"
    end
  })

  scope :with_genre, (->(genre_ids) { joins(:genres).where(genres: { id: genre_ids }) })

  scope :charted, (-> { where(is_charted: true) })

  scope :sorted_by_sort_name, (lambda { |value|
    value = 'desc' unless value
    order("created_at #{value}") if %w[desc asc].include? value
  })

  scope :types, (->(values) { where(values.symbolize_keys) })
  scope :subgenres, (->(values) { includes(:subgenres).where('subgenres.id' => values) })
  scope :ratings, (->(values) { includes(:ratings).rating_statuses(values).order_by_rating(values) })
  scope :rating_statuses, (->(values) { where('ratings.status' => values.map { |v| Rating.statuses[v] }) })
  scope :order_by_rating, (->(values) { order(values.collect { |c| "#{c}_count desc" }.join(', ')) })
  scope :sort_by, (->(value) { order("tracks.created_at #{value}") })
  scope :streamable_tracks, (-> { where(streamable: true) })
  scope :beats_for_user, (->(user) { where('streamable = true OR user_id = ?', user&.id) })

  delegate :username, to: :user

  def update_with_tag_list(list)
    self.has_vocals   = true if list.include? 'vocals'
    self.has_samples  = true if list.include? 'samples'
    self.downloadable = true if list.include? 'free'
    self.contactable  = true if list.include? 'contactable'
    self.streamable   = true if list.include? 'public'
  end

  def self.time_ago(time)
    track_arel = Track.arel_table
    time_range = case time
                 when '24hrs'  then  24.hours.ago
                 when 'week'   then  1.week.ago
                 when 'month'  then  1.month.ago
                 when 'year'   then  1.year.ago
                 else
                   Track.first.try(:created_at) || Time.now
                 end
    where(track_arel[:created_at].gteq(time_range))
  end

  def visible?
    streamable ? true : false
  end

  def self.options_for_sorted_by_extended
    [
      ['Newest - Oldest', 'created_at_desc'],
      ['Oldest - Newest', 'created_at_asc'],
      ['Rating asc', 'rating_asc'],
      ['Rating desc', 'rating_desc'],
      %w[Charted charted]
    ]
  end

  def track_count
    Tracker.track(user.name,
                  'Beat Uploaded',
                  beat_name: title,
                  all_beats_count: Track.count,
                  users_track_count: user.tracks.count)
  end

  def chart_number
    order_number = 0
    tracks = Track.pluck(:id).order(rating: :desc).limit(100)
    tracks.each_with_index do |track, i|
      order_number = i + 1
      next if track.id == id
    end
    order_number
  end

  def ratings_count(rating_type)
    ratings.where(rating_type: rating_type).count
  end

  def self.random
    order('RANDOM()').first
  end

  def apply_email_data_to_user(data)
    user.email_data[title.to_s] = data
    user.save!
  end
end
