class AddImageDataToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :image_data, :text
  end
end
