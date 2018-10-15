module TrackFilter
  extend ActiveSupport::Concern

  included do
    has_one :by_day_chart,     -> { by_this_day }, class_name: Track::Charted
    has_one :by_week_chart,     -> { by_this_week }, class_name: Track::Charted
    has_one :by_month_chart,    -> { by_this_month }, class_name: Track::Charted
    has_one :by_all_time_chart, -> { by_all_time }, class_name: Track::Charted

    CHARTS_LIMIT      = 25
    ORDER_SCOPES      = %w(by_day_charts by_week_charts by_month_charts by_all_time_charts).freeze
    ORDER_SCOPES_JOB  = %w(charts_by_week_job charts_by_month_job charts_by_all_time_job).freeze

    scope :public_tracks, -> { where(streamable: true) }

    scope :charted_by_period, lambda { |sort|
      scope = ORDER_SCOPES.include?(sort) ? sort : 'by_week_charts'
      public_tracks.includes(:user).send(scope)
    }

    # Charts Scopes
    # scope :by_today_charts, -> (time = DateTime.now) {
    #   joins_ratings
    #     .with_count_ratings
    #     .order_by_ratings_interval
    #     .where('ratings.updated_at > :time', time: time.beginning_of_day)
    #     .with_count_ratings_by_period('today')
    # }

    scope :joins_track_charted, -> (query = {}) { joins(:track_charted).where(track_charted: query).order('track_charted.position asc') }
    scope :by_day_charts,       -> { joins_track_charted(type: 'Track::Day').includes(:by_day_chart) }
    scope :by_week_charts,      -> { joins_track_charted(type: 'Track::Week').includes(:by_week_chart) }
    scope :by_month_charts,     -> { joins_track_charted(type: 'Track::Month').includes(:by_month_chart) }
    scope :by_all_time_charts,  -> { joins_track_charted(type: 'Track::AllTime').includes(:by_all_time_chart) }
    scope :all_charted_tracks, -> { where(is_charted: true) }
    scope :charted_by_period_job, lambda { |sort|
      scope = ORDER_SCOPES_JOB.include?(sort) ? sort : 'charts_by_week_job'
      public_tracks
        .joins_ratings
        .with_count_ratings
        .send(scope)
        .limit(CHARTS_LIMIT)
    }
    scope :charts_by_day_job,      -> { with_count_ratings_by_period('day').order_by_ratings_interval }
    scope :charts_by_week_job,      -> { with_count_ratings_by_period('week').order_by_ratings_interval }
    scope :charts_by_month_job,     -> { with_count_ratings_by_period('month').order_by_ratings_interval }
    scope :charts_by_all_time_job,  -> { order(order_all_time) }

    # helpers to eager load Relationships (RATING, CRITIQUE, etc.)

    scope :joins_ratings, lambda {
      joins('LEFT OUTER JOIN ratings ON ratings.track_id = tracks.id')
        .joins('LEFT OUTER JOIN users ON users.id = tracks.user_id')
        .group('tracks.id').select('tracks.*')
    }

    scope :with_count_ratings, lambda {
      select("#{count_ratings_by_type('like')} as count_like,
             #{count_ratings_by_type('dislike')} as count_dislike,
             (#{count_ratings_by_type('like')} - #{count_ratings_by_type('dislike')}) as count_total_like")
    }

    scope :with_count_ratings_by_period, lambda { |interval = 'month', date = DateTime.now|
      select("#{count_ratings_by_type_interval('like', interval, date)} as count_like_interval,
               #{count_ratings_by_type_interval('dislike', interval, date)} as count_dislike_interval,
               (#{count_ratings_by_type_interval('like', interval, date)} - #{count_ratings_by_type_interval('dislike', interval, date)}) as count_total_like_interval")
    }

    scope :order_by_ratings_interval, lambda {
      order("count_total_like_interval desc, count_like_interval desc, count_dislike_interval asc, tracks.created_at desc")
    }

    scope :order_by_ratings, -> { order(order_all_time) }

    def chart_by_period(interval, counter = 1, page = 1, show_position = false)
      method = ORDER_SCOPES.include?(interval) ? interval.singularize : 'by_day_chart'
      return if method == 'by_day_chart' && !show_position
      method == 'by_day_chart' ? counter * page : send(method)&.position
    end

    class << self
      private

      def count_ratings_by_type(type)
        "SUM(case when ratings.status = #{Rating.statuses[type]} then 1 else 0 end)"
      end

      def count_ratings_by_type_interval(type, interval, date)
        if interval == 'today'
          "SUM(case when ratings.status = #{Rating.statuses[type]} then 1 else 0 end)"
        else
          "SUM(case when ratings.status = #{Rating.statuses[type]} AND extract(#{interval} from ratings.updated_at) = #{number_interval(date)[interval]} AND extract(year from ratings.updated_at) = #{date.year} then 1 else 0 end)"
        end
      end

      def number_interval(date)
        { 'month' => date.month,
          'week' => date.cweek,
          'day' => date.yday}
      end

      def order_all_time
        'count_total_like desc, count_like desc, count_dislike asc, tracks.created_at desc'
      end
    end
  end
end
