class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
    	t.text :description
    	t.integer :badge_duty_id
    	t.string :badge_duty_type
    	t.datetime :date_granted, null: false
    	t.timestamps null: false
    end
  end
end
