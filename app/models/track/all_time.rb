class Track::AllTime < Track::Charted
  validates :track_id, uniqueness: true
  validates :position, uniqueness: true

  class << self
    def chart
      datetime      = DateTime.now
      track_charted = Track.charted_by_period_job('charts_by_all_time_job')

      Track::AllTime.delete_all
      track_charted.each_with_index do |track, index|
        charted = Track::AllTime.create!(
          track_id: track.id,
          year: nil,
          day: nil,
          week: nil,
          month: nil,
          date: datetime,
          position: (index + 1)
        )

        track.apply_email_data_to_user(process_position_changes(track))
        charted.update_track_previous_positions
        charted.update_track_all_time_position(track)
        charted.grant_badge(track, datetime, track.is_charted)
        track.update(is_charted: true)
      end
    end
  end
end
