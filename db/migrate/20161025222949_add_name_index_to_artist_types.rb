class AddNameIndexToArtistTypes < ActiveRecord::Migration
  def change
  	add_index :artist_types, :name, unique: true
  end
end
