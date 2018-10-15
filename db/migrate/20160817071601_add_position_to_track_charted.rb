class AddPositionToTrackCharted < ActiveRecord::Migration
  def change
    add_column :track_charted, :position, :integer
  end
end
