class AddTagListToTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :tracks, :tag_list, :text
  end
end
