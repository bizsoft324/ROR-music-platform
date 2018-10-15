class AddAllTimePositionToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :all_time_position, :integer
  end
end
