class DropMailboxerTables < ActiveRecord::Migration
  def change
  	drop_table :mailboxer_receipts, force: :cascade
  	drop_table :mailboxer_conversations, force: :cascade
  end
end
