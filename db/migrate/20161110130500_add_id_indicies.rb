class AddIdIndicies < ActiveRecord::Migration
  def change
    add_index :comments, :critique_id
    add_index :critiques, :track_id
    add_index :identities, :user_id
    add_index :soundbites, :comment_id
    add_index :soundbites, :critique_id
    add_index :tracks, :artist_type_id
  end
end
