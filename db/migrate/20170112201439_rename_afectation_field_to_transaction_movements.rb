class RenameAfectationFieldToTransactionMovements < ActiveRecord::Migration
  def change
    rename_column :transaction_movements, :afectation, :accounting_entry
  end
end
