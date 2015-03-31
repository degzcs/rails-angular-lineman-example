class UndoFixColumnNameIdRucoms < ActiveRecord::Migration
  def self.up
    rename_column :rucoms, :id, :idrucom
  end

  def self.down
    # rename back if you need or do something else or do nothing
    rename_column :rucoms, :idrucom, :id
  end
end
