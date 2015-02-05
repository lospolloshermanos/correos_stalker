class AddConfirmedColumn < ActiveRecord::Migration
  def change
    add_column :correos_checkers, :confirmed, :boolean, :default => false
  end
end
