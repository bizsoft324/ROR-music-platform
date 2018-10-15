class AddCritiquesCountToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :critiques_count, :integer, default: 0

    Track.reset_column_information
    Track.find_each do |t|
      Track.update_counters t.id, critiques_count: t.critiques.count
    end
  end
end
