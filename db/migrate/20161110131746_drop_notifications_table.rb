class DropNotificationsTable < ActiveRecord::Migration
  def change
    drop_table :notifications
  end
end
