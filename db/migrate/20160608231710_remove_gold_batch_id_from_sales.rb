class RemoveGoldBatchIdFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :gold_batch_id, :integer
  end
end
