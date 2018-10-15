class AddRatingAndSocialSharesToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :rating, :float, default: 0
    add_column :tracks, :social_shares, :integer, default: 0
  end
end
