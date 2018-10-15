class TrackDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Track.user_id Track.title)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Track.user_id Track.title)
  end

  private

  def data
    records.map do |record|
      next if record.nil?
      [
        record.user.try(:username),
        record.try(:title),
        link_to('delete', "/admin/tracks/#{record.id}", method: :delete)
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
      ]
    end
  end

  def get_raw_records
    Track.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
