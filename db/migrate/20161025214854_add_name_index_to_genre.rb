class AddNameIndexToGenre < ActiveRecord::Migration
  def change
  	add_index :genres, :name, unique: true
  end
end
