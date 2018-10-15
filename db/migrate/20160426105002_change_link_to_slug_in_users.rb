class ChangeLinkToSlugInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :link, :string
    add_column :users, :slug, :string
  end
end
