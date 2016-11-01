class AddTransactionStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :transaction_state, :string
  end
end
