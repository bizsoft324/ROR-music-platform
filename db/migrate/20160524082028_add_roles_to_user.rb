class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :jsonb, null: :false, default: '{ "admin": false, "producer": false }'
    add_index :users, :roles, using: :gin
  end
end
