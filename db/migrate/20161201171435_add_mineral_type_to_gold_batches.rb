class AddMineralTypeToGoldBatches < ActiveRecord::Migration
  def change
    add_column :gold_batches, :mineral_type, :string
  end
end
