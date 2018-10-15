class AddPreviousPositionsToTracks < ActiveRecord::Migration[5.0]
  def change
  	add_column :tracks, :previous_positions, :jsonb, default: {}
  end
end
