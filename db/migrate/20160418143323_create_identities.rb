class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references  :user,             null: false
      t.string   :uid
      t.string   :avatar_url
      t.string   :refresh_token
      t.string   :access_token_secret
      t.string   :provider,            null: false
      t.string   :access_token,        null: false
      t.datetime :expires_at

      t.timestamps                     null: false
    end

    add_index :identities, [:provider, :uid]
  end
end
