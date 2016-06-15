class AddGoldBatchIdToSoldBatches < ActiveRecord::Migration
  def change
    add_column :sold_batches, :gold_batch_id, :integer
    add_index :sold_batches, :gold_batch_id
  end
end
