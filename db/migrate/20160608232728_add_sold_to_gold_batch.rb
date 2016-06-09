class AddSoldToGoldBatch < ActiveRecord::Migration
  def change
    add_column :gold_batches, :sold, :boolean, default: false
  end
end
