class ChangeRatingsIndex < ActiveRecord::Migration
  def change
  	remove_index :ratings, :track_id
  	remove_index :ratings, :user_id

  	add_index :ratings, [:user_id, :track_id], unique: true
  end
end
