class RemovePurchaseIdFromSoldBatches < ActiveRecord::Migration
  def change
    remove_column :sold_batches, :purchase_id, :integer
  end
end
