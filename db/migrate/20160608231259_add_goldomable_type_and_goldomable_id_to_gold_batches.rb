class AddGoldomableTypeAndGoldomableIdToGoldBatches < ActiveRecord::Migration
  def change
    add_column :gold_batches, :goldomable_type, :string
    add_column :gold_batches, :goldomable_id, :integer
    add_index :gold_batches, :goldomable_id
  end
end
