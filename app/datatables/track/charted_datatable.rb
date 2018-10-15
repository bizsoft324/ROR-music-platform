class Track::ChartedDatatable < AjaxDatatablesRails::Base
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Track::Charted.track_id Track::Charted.year Track::Charted.month Track::Charted.week Track::Charted.day Track::Charted.date Track::Charted.position Track::Charted.previous_position)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Track::Charted.track_id Track::Charted.year Track::Charted.month Track::Charted.week Track::Charted.day Track::Charted.date Track::Charted.position Track::Charted.previous_position)
  end

  private

  def data
    records.map do |record|
      next if record.nil?
      [
        record.track.try(:title),
        record.year,
        record.month,
        record.week,
        record.day,
        record.date,
        record.position,
        record.previous_position
      ]
    end
  end

  def get_raw_records
    Track::Charted.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
