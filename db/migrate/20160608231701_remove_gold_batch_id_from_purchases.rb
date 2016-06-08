class RemoveGoldBatchIdFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :gold_batch_id, :integer
  end
end
