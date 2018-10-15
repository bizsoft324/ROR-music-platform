class DropTable < ActiveRecord::Migration
  def change
  	drop_table :mailboxer_conversation_opt_outs
  end
end
