class CreateCorreosChecker < ActiveRecord::Migration
  def change
    create_table :correos_checkers do |t|
      t.string    :email
      t.string    :tracking_number
      t.string    :status
      t.datetime  :completed_at

      t.timestamps
    end
    add_index :correos_checkers, :tracking_number, unique: true
    add_index :correos_checkers, :email
  end
end
