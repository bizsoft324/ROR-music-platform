class AddUniqIndexToGenresTracksAndSubgenresTracks < ActiveRecord::Migration
  def up
    Track.find_each do |track|
      double_genres = track.genres.group("genres.id").having("COUNT(genres.id)>1")
      double_genres.each do |double_genre|
        track.genres.delete(double_genre)
        track.genres << double_genre
      end
      double_subgenres = track.subgenres.group("subgenres.id").having("COUNT(subgenres.id)>1")
      double_subgenres.each do |double_subgenre|
        track.double_subgenres.delete(double_subgenre)
        track.double_subgenres << double_subgenre
      end
    end

    add_index :genres_tracks, [:genre_id, :track_id], unique: true
    add_index :subgenres_tracks, [:subgenre_id, :track_id], unique: true
  end

  def down
    remove_index :genres_tracks, [:genre_id, :track_id], unique: true
    remove_index :subgenres_tracks, [:subgenre_id, :track_id], unique: true
  end
end
