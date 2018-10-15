class AddStatusToRatings < ActiveRecord::Migration
  def up
    add_column :ratings, :status, :integer

    Rating.find_each do |rating|
      rating.update(status: Rating.statuses[rating.rating_type]) if rating.rating_type
    end

    remove_column :ratings, :rating_type
  end

  def down
    add_column :ratings, :rating_type, :string

    Rating.find_each do |rating|
      rating.update(rating_type: rating.status) if rating.status
    end

    remove_column :ratings, :status
  end
end
