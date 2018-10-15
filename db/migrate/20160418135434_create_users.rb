class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :username
      t.string   :country
      t.string   :city
      t.string   :first_name
      t.string   :last_name
      t.string   :email,                 index: true
      t.string   :description
      t.string   :token,                 index: true
      t.string   :reset_password_token,  index: true
      t.datetime :last_activity_at
      t.string   :avatar
      t.boolean  :confirmed,             default: false
      t.string   :password_digest

      t.timestamps                       null: false
    end
  end
end
