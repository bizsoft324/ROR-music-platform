class AddEmailDataToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :email_data, :jsonb, default: {}
  end
end
