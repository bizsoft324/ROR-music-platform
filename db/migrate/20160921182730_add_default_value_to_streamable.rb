class AddDefaultValueToStreamable < ActiveRecord::Migration
  def change
    change_column :tracks, :streamable, :boolean,  :default => true
    change_column :tracks, :commentable, :boolean, :default => true
  end
end
