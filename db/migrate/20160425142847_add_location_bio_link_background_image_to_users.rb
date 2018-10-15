class AddLocationBioLinkBackgroundImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :bio, :text
    add_column :users, :link, :string
    add_column :users, :background_image, :string
    add_column :users, :is_visible, :boolean, default: true
  end
end
