class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references  :user,        null: false, index: true
      t.references  :track,       null: false, index: true
      t.string      :rating_type

      t.timestamps                null: false
    end
  end
end
