class AddContactableToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :contactable, :boolean
    add_index :tracks, :contactable
  end
end
