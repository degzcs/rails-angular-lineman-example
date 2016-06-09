class RemoveInventoryIdFromGoldBatches < ActiveRecord::Migration
  def change
    remove_column :gold_batches, :inventory_id, :integer
  end
end
