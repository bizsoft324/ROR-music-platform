class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references  :critique,             null: false
      t.references  :user,             null: false
      t.integer  :commentable_id
      t.string   :commentable_type
      t.string   :title
      t.text     :body
      t.string   :subject
      t.integer  :parent_id
      t.integer  :lft
      t.integer  :rgt

      t.timestamps                     null: false
    end

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
