class CreateTrackCharteds < ActiveRecord::Migration
  def change
    create_table :track_charted do |t|
      t.integer :track_id
      t.integer :year
      t.integer :month
      t.integer :week
      t.integer :day
      t.datetime :date

      t.timestamps null: false
    end
  end
end
