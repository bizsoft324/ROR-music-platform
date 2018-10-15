class AddIndexIntoRatingColumn < ActiveRecord::Migration
  def change
    add_index :tracks, :rating
  end
end
