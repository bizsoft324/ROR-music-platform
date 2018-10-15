class AddIndexToArtistSubdomains < ActiveRecord::Migration[5.0]
  def change
  	add_index :artist_subdomains, :slug, unique: true
  end
end
