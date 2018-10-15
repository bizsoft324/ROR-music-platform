class CreateArtistSubdomains < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_subdomains do |t|
    	t.string :domain
    	t.string :slug
    	t.references :user
    end
  end
end
