class Rating < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :track

  validates_uniqueness_of :user_id, scope: :track_id
  after_save :set_ratings_count_for_track, :rating_callback
  enum status: %i[like dislike indifferent]

  scope :recent, (-> { order(created_at: :desc) })
  scope :old, (-> { order(created_at: :asc) })
  scope :send_order, (lambda { |scope|
    scope = 'recent' unless scope
    send(scope) if %w[recent old].include? scope
  })

  private

  def set_ratings_count_for_track
    return unless status_changed?
    ratings           = Rating.select(:track_id, :status).where(track_id: track.id)
    like_count        = ratings.select(&:like?).count
    indifferent_count = ratings.select(&:indifferent?).count
    dislike_count     = ratings.select(&:dislike?).count
    track.update_columns(like_count: like_count, indifferent_count: indifferent_count, dislike_count: dislike_count)
  end

  def rating_callback
    Tracker.track(track.title, 'Rating left', user: user.name, status: status)
  end
end
