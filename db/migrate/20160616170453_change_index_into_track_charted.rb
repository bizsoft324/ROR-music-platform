class ChangeIndexIntoTrackCharted < ActiveRecord::Migration
  def change
    remove_index :track_charted, name: 'index_track_charted_on_year_and_week'
    remove_index :track_charted, name: 'index_track_charted_on_year_and_month'
    add_index :track_charted, [:track_id, :year, :week]
    add_index :track_charted, [:track_id, :year, :month]
  end
end
