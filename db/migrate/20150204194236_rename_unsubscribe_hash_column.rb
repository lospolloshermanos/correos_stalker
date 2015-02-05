class RenameUnsubscribeHashColumn < ActiveRecord::Migration
  def change
    rename_column :correos_checkers, :unsubscribe_hash, :token
  end
end
