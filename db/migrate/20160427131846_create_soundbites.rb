class CreateSoundbites < ActiveRecord::Migration
  def change
    create_table :soundbites do |t|
      t.integer :comment_id
      t.integer :critique_id
      t.string :data_url
      t.integer :data_id
      t.integer :data_start
      t.integer :data_end
      t.integer :data_plays
      t.string :title

      t.timestamps null: false
    end
  end
end
