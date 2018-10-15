class Track::Charted < ActiveRecord::Base
  self.table_name = 'track_charted'

  belongs_to :track

  scope :by_this_day, (->(time = DateTime.now) { where(year: time.year, day: time.yday) })
  scope :by_this_week,  (->(time = DateTime.now) { where(year: time.year, week: time.cweek) })
  scope :by_this_month, (->(time = DateTime.now) { where(year: time.year, month: time.month) })
  scope :by_all_time,   (-> { where(year: nil, month: nil, week: nil) })

  def update_track_all_time_position(track)
    while track.all_time_position.nil? || track.all_time_position > position
      track.update(all_time_position: position)
    end
  end

  def grant_badge(track, datetime, is_charted)
    track.badges.create(description: 'this track has been charted', badge_duty_type: 'charted', date_granted: datetime) unless is_charted
  end

  def update_track_previous_positions
    scope = type[7..13]
    track.previous_positions[scope] = {}
    track.previous_positions[scope]['position'] = position
    track.save!
  end

  def self.process_position_changes(track)
    @data = {}
    %w(Day Week Month AllTime).each do |scope|
      chart = track.track_charted.where(type: "Track::#{scope}").first
      if track.previous_positions[scope] && chart
        if track.previous_positions[scope].values.first != chart.position
          @direction = track.previous_positions[scope].values.first > chart.position ? 'up' : 'down'
        else
          @direction = nil
        end
        @data[scope] = { 'position' => chart.position }
        @data[scope]['moved'] = {  @direction => (track.previous_positions[scope].values.first - chart.position).abs } if @direction
        @data['top_ten'] = true if chart.position <= 10
      else
        next
      end
    end
    @data
  end
end
