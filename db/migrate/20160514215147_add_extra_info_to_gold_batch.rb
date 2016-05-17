class AddExtraInfoToGoldBatch < ActiveRecord::Migration
  def change
    add_column :gold_batches, :extra_info, :text
  end
end
