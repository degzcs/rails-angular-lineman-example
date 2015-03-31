class AddIdToRucoms < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE rucoms DROP CONSTRAINT rucoms_pkey"
  	add_column :rucoms, :id, :primary_key
  end
end
