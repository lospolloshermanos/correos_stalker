class AddIndexToUnsubscribeHash < ActiveRecord::Migration
  def change
  	add_index :correos_checkers, :unsubscribe_hash, unique: true
  end
end
