class AddDescriptionToCorreosCheckers < ActiveRecord::Migration
  def change
    add_column :correos_checkers, :description, :text
  end
end
