class AddTransactionSequenceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :transaction_sequence, :integer
  end
end
