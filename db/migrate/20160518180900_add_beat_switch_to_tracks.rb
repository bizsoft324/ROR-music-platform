class AddBeatSwitchToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :has_beat_switch, :boolean
  end
end
