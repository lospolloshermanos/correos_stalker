class AddUnsubscribeHashToCorreosChecker < ActiveRecord::Migration
  def change
    add_column :correos_checkers, :unsubscribe_hash, :string
  end
end
