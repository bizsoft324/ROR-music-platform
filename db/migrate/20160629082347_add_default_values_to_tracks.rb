class AddDefaultValuesToTracks < ActiveRecord::Migration
  def change
    change_column :tracks, :has_samples, :boolean, default: false
    change_column :tracks, :has_vocals, :boolean, default: false
    change_column :tracks, :contactable, :boolean, default: false
    change_column :tracks, :streamable, :boolean, default: false
    change_column :tracks, :downloadable, :boolean, default: false
    change_column :tracks, :sharing, :boolean, default: false
  end
end
