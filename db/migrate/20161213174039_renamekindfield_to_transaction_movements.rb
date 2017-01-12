class RenamekindfieldToTransactionMovements < ActiveRecord::Migration
  def self.up
    rename_column :transaction_movements, :kind, :type
  end

  def self.down
    # rename back if you need or do something else or do nothing
    rename_column :transaction_movements, :type, :kind
  end
end
