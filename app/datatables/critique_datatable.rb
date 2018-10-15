class CritiqueDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Comment.user_id Comment.body Comment.commentable_id)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Comment.user_id Comment.body Comment.commentable_id)
  end

  private

  def data
    records.map do |record|
      next if record.nil?
      [
        record.user.try(:username),
        record.try(:body),
        Track.find(record.commentable_id).try(:title),
        link_to('delete', "/admin/critiques/#{record.id}", method: :delete)
      ]
    end
  end

  def get_raw_records
    Comment.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
