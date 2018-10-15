class ChangeIndexOnTrackCharted < ActiveRecord::Migration
  def change
    remove_index :track_charted, [:track_id, :year, :month]
    remove_index :track_charted, [:track_id, :year, :week]

    add_index :track_charted, [:track_id, :year, :month], unique: true
    add_index :track_charted, [:track_id, :year, :week], unique: true

  end
end
