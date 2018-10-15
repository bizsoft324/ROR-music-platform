class Track::Week < Track::Charted
  class << self
    def chart
      datetime      = DateTime.now
      track_charted = Track.charted_by_period_job('charts_by_week_job')
      Track::Week.all.each do |track_week|
        Track.where(id: track_week.track_id).update(previous_position: track_week.position)
      end

      Track::Week.delete_all
      track_charted.each_with_index do |track, index|
        charted = Track::Week.create!(
          track_id: track.id,
          year: datetime.year,
          week: datetime.cweek
        )
        charted.date = datetime
        charted.update(position: (index + 1))
        charted.update_track_all_time_position(track)
        next unless charted.save!
        charted.grant_badge(track, datetime, track.is_charted)
        charted.email_update(track, track.is_charted)
        track.update(is_charted: true) unless track.is_charted
      end
    end
  end
end
