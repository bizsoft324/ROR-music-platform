class AddWaveformToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :waveform, :float, array: true, default: []
  end
end
