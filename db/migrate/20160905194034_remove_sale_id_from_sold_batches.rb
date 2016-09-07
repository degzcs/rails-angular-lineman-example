class RemoveSaleIdFromSoldBatches < ActiveRecord::Migration
  def change
    remove_column :sold_batches, :sale_id, :integer
  end
end
