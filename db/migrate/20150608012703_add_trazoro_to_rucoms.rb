class AddTrazoroToRucoms < ActiveRecord::Migration
  def change
    add_column :rucoms, :trazoro, :boolean, default: false, null: false
  end
end
