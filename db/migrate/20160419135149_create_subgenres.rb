class CreateSubgenres < ActiveRecord::Migration
  def change
    create_table :subgenres do |t|
      t.string :name
      t.belongs_to :genre, index: true

      t.timestamps null: false
    end
  end
end
