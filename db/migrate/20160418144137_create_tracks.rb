class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.references  :user,        null: false, index: true
      t.string   :soundcloud_uri
      t.string   :artwork_url
      t.string   :permalink
      t.text     :description
      t.integer  :duration
      t.boolean  :sharing
      t.boolean  :commentable
      t.boolean  :streamable
      t.boolean  :downloadable
      t.boolean  :has_vocals,     index: true
      t.boolean  :has_samples,    index: true
      t.string   :title
      t.boolean  :marked,         default: false, null: false
      t.text     :audio_data

      t.timestamps                null: false
    end
  end
end
