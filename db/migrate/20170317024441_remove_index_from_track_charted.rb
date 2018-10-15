class RemoveIndexFromTrackCharted < ActiveRecord::Migration[5.0]
  def change
    ActiveRecord::Base.connection.indexes('track_charted').each do |index|
      remove_index :track_charted, :name => index.name
    end
  end
end
