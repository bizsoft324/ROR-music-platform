class AddTypeToTrackCharted < ActiveRecord::Migration[5.0]
  def change
  	add_column :track_charted, :type, :string
  end
end
