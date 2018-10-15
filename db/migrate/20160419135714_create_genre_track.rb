class CreateGenreTrack < ActiveRecord::Migration
  def change
    create_table :genres_tracks, id: false do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :track, index: true
    end

    create_table :subgenres_tracks, id: false do |t|
      t.belongs_to :subgenre, index: true
      t.belongs_to :track, index: true
    end
  end
end
