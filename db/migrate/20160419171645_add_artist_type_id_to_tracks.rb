class AddArtistTypeIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :artist_type_id, :integer, index: true
  end
end
