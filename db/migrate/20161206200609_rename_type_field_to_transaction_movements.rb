class RenameTypeFieldToTransactionMovements < ActiveRecord::Migration
  def  up
    rename_column :transaction_movements, :type, :kind
  end

  def  down
    rename_column :transaction_movements, :kind, :type
  end
end
