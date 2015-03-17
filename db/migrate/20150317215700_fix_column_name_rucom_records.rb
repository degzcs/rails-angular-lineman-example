class FixColumnNameRucomRecords < ActiveRecord::Migration
  def self.up
    rename_column :rucoms, :record, :rucom_record
  end

  def self.down
    # rename back if you need or do something else or do nothing
    rename_column :rucoms, :rucom_record, :record
  end
end
