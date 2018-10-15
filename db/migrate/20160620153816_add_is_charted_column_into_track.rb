class AddIsChartedColumnIntoTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :is_charted, :boolean, default: false
  end
end
