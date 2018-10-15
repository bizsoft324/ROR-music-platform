class CreateCritiques < ActiveRecord::Migration
  def change
    create_table :critiques do |t|
      t.references  :track, null: false

      t.timestamps          null: false
    end
  end
end
