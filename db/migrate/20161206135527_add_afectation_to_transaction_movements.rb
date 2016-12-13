class AddAfectationToTransactionMovements < ActiveRecord::Migration
  def change
    add_column :transaction_movements, :afectation, :string
  end
end
