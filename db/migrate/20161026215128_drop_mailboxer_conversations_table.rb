class DropMailboxerConversationsTable < ActiveRecord::Migration
  def change
  	drop_table :mailboxer_notifications, force: :cascade

  end
end
