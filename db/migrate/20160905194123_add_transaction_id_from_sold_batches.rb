class AddTransactionIdFromSoldBatches < ActiveRecord::Migration
  def change
    add_column :sold_batches, :order_id, :integer
  end
end
