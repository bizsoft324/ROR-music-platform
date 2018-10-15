class AddNameIndexToSubgenres < ActiveRecord::Migration
  def change
  	add_index :subgenres, :name, unique: true
  end
end
