class UserDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(User.username User.first_name User.last_name User.email)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(User.username User.first_name User.last_name User.email)
  end

  private

  def data
    records.map do |record|
      next if record.nil?
      [
        record.try(:username),
        record.try(:first_name),
        record.try(:last_name),
        record.try(:email),
        link_to('delete', "/admin/users/#{record.id}", method: :delete)
      ]
    end
  end

  def get_raw_records
   User.all
  end
  # ==== Insert 'presenter'-like methods below if necessary
end
