class AddCountColumnsForRating < ActiveRecord::Migration
  def change
    add_column :tracks, :like_count, :integer, default: 0
    add_column :tracks, :indifferent_count, :integer, default: 0
    add_column :tracks, :dislike_count, :integer, default: 0
    Track.find_in_batches(batch_size: 100).each do |tracks|
      tracks.each do |track|
        like_count        = track.ratings.where(rating_type: 'like').count
        indifferent_count = track.ratings.where(rating_type: 'indifferent').count
        dislike_count     = track.ratings.where(rating_type: 'dislike').count
        track.update_columns(like_count: like_count, indifferent_count: indifferent_count, dislike_count: dislike_count)
      end
    end

  end
end
