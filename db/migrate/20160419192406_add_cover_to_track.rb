class AddCoverToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :cover, :string
  end
end
