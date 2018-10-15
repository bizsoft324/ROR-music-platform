class AddIndexIntoTrackCharted < ActiveRecord::Migration
  def change
    add_index :track_charted, [:year, :week]
    add_index :track_charted, [:year, :month]
  end
end
