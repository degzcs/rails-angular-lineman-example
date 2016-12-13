class RenameInitialsfieldToTaxes < ActiveRecord::Migration
  def self.up
    rename_column :taxes, :initials, :reference
  end

  def self.down
    # rename back if you need or do something else or do nothing
    rename_column :taxes, :reference, :initials
  end
end
