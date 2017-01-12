class CreateTransactionMovements < ActiveRecord::Migration
  def change
    create_table :transaction_movements do |t|
      t.references :puc_account, index: true
      t.string :type
      t.string :block_name

      t.timestamps
    end
  end
end
