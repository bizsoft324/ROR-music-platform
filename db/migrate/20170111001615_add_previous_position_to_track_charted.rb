class AddPreviousPositionToTrackCharted < ActiveRecord::Migration
  def change
  	add_column :track_charted, :previous_position, :integer
  end
end
